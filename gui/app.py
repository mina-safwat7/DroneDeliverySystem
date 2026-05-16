import tkinter as tk
from tkinter import ttk, messagebox, filedialog
import pyodbc
import csv

# ---------------------------------------------------------------
# DATABASE CONNECTION
# ---------------------------------------------------------------
CONNECTION_STRING = (
    "Driver={ODBC Driver 17 for SQL Server};"
    "Server=.\SQLEXPRESS;"
    "Database=DroneDelivery;"
    "Trusted_Connection=yes;"
)

def get_connection():
    try:
        return pyodbc.connect(CONNECTION_STRING)
    except Exception as e:
        messagebox.showerror("Connection Error", str(e))
        return None


# ---------------------------------------------------------------
# TABLE METADATA
# ---------------------------------------------------------------
TABLES = {
    "Staff": {
        "pk": "StaffID",
        "identity": True,
        "columns": ["FirstName", "LastName", "Role", "PhoneNumber", "Email"],
        "all": ["StaffID", "FirstName", "LastName", "Role", "PhoneNumber", "Email"],
    },
    "Drone": {
        "pk": "DroneID",
        "identity": True,
        "columns": ["DroneName", "BatteryPercentage", "MaxWeightCapacityKG", "Status", "StaffID"],
        "all": ["DroneID", "DroneName", "BatteryPercentage", "MaxWeightCapacityKG", "Status", "StaffID"],
    },
    "Customer": {
        "pk": "CustomerID",
        "identity": True,
        "columns": ["FirstName", "LastName", "Address", "City", "State", "ZipCode", "PhoneNumber", "Email"],
        "all": ["CustomerID", "FirstName", "LastName", "Address", "City", "State", "ZipCode", "PhoneNumber", "Email"],
    },
    "Location": {
        "pk": "LocationID",
        "identity": True,
        "columns": ["Address", "City", "State", "ZipCode", "Latitude", "Longitude"],
        "all": ["LocationID", "Address", "City", "State", "ZipCode", "Latitude", "Longitude"],
    },
    "Package": {
        "pk": "PackageID",
        "identity": True,
        "columns": ["WeightKG", "DimensionsCM", "Status", "CustomerID"],
        "all": ["PackageID", "WeightKG", "DimensionsCM", "Status", "CustomerID"],
    },
    "Delivery": {
        "pk": "DeliveryID",
        "identity": True,
        "columns": ["DroneID", "PackageID", "CustomerID", "OriginLocationID",
                    "DestinationLocationID", "DeliveryStatus",
                    "ScheduledDateTime", "ActualDeliveryDateTime"],
        "all": ["DeliveryID", "DroneID", "PackageID", "CustomerID", "OriginLocationID",
                "DestinationLocationID", "DeliveryStatus",
                "ScheduledDateTime", "ActualDeliveryDateTime"],
    },
    "BatteryLog": {
        "pk": "LogID",
        "identity": True,
        "columns": ["DroneID", "Timestamp", "BatteryPercentage"],
        "all": ["LogID", "DroneID", "Timestamp", "BatteryPercentage"],
    },
}


# ---------------------------------------------------------------
# MAIN APPLICATION
# ---------------------------------------------------------------
class DroneApp(tk.Tk):
    def __init__(self):
        super().__init__()
        self.title("Warehouse Drone Delivery — Management System")
        self.geometry("1200x720")
        self.configure(bg="#f0f4f8")

        self._setup_style()
        self._build_ui()

    def _setup_style(self):
        style = ttk.Style(self)
        style.theme_use("clam")
        style.configure("TNotebook", background="#f0f4f8")
        style.configure("TNotebook.Tab", padding=[14, 8], font=("Segoe UI", 10, "bold"))
        style.configure("Treeview.Heading", font=("Segoe UI", 10, "bold"),
                        background="#2c3e50", foreground="white")
        style.configure("Treeview", font=("Segoe UI", 10), rowheight=24)
        style.configure("TButton", font=("Segoe UI", 10), padding=6)
        style.configure("TLabel", background="#f0f4f8", font=("Segoe UI", 10))
        style.configure("Header.TLabel", font=("Segoe UI", 14, "bold"),
                        background="#2c3e50", foreground="white", padding=10)

    def _build_ui(self):
        header = ttk.Label(self, text="🛸 Warehouse Drone Delivery System",
                           style="Header.TLabel", anchor="center")
        header.pack(fill="x")

        self.notebook = ttk.Notebook(self)
        self.notebook.pack(fill="both", expand=True, padx=10, pady=10)

        self.tabs = {}
        for table in TABLES.keys():
            tab = TableTab(self.notebook, table)
            self.notebook.add(tab, text=table)
            self.tabs[table] = tab


# ---------------------------------------------------------------
# GENERIC CRUD TAB
# ---------------------------------------------------------------
class TableTab(ttk.Frame):
    def __init__(self, parent, table_name):
        super().__init__(parent)
        self.table_name = table_name
        self.meta = TABLES[table_name]
        self.entries = {}
        self.selected_pk = None

        self._build()
        self.load_data()

    def _build(self):
        # ---------- Left: form ----------
        form_frame = ttk.LabelFrame(self, text=f"{self.table_name} Details", padding=10)
        form_frame.pack(side="left", fill="y", padx=10, pady=10)

        for i, col in enumerate(self.meta["columns"]):
            ttk.Label(form_frame, text=col + ":").grid(row=i, column=0, sticky="w", pady=4)
            entry = ttk.Entry(form_frame, width=30)
            entry.grid(row=i, column=1, pady=4, padx=5)
            self.entries[col] = entry

        btn_frame = ttk.Frame(form_frame)
        btn_frame.grid(row=len(self.meta["columns"]), column=0, columnspan=2, pady=15)

        ttk.Button(btn_frame, text="➕ Insert", command=self.insert).grid(row=0, column=0, padx=3)
        ttk.Button(btn_frame, text="✏️ Update", command=self.update).grid(row=0, column=1, padx=3)
        ttk.Button(btn_frame, text="🗑 Delete", command=self.delete).grid(row=0, column=2, padx=3)
        ttk.Button(btn_frame, text="🧹 Clear", command=self.clear_form).grid(row=1, column=0, padx=3, pady=5)
        ttk.Button(btn_frame, text="🔄 Refresh", command=self.load_data).grid(row=1, column=1, padx=3, pady=5)
        ttk.Button(btn_frame, text="💾 Export CSV", command=self.export_csv).grid(row=1, column=2, padx=3, pady=5)

        # ---------- Right: search + table ----------
        right = ttk.Frame(self)
        right.pack(side="right", fill="both", expand=True, padx=10, pady=10)

        search_frame = ttk.Frame(right)
        search_frame.pack(fill="x", pady=5)
        ttk.Label(search_frame, text="🔍 Search:").pack(side="left", padx=5)

        self.search_col = ttk.Combobox(search_frame, values=self.meta["all"],
                                       state="readonly", width=20)
        self.search_col.current(0)
        self.search_col.pack(side="left", padx=5)

        self.search_entry = ttk.Entry(search_frame, width=30)
        self.search_entry.pack(side="left", padx=5)
        self.search_entry.bind("<Return>", lambda e: self.search())

        ttk.Button(search_frame, text="Search", command=self.search).pack(side="left", padx=5)
        ttk.Button(search_frame, text="Show All", command=self.load_data).pack(side="left", padx=5)

        # Treeview
        tree_frame = ttk.Frame(right)
        tree_frame.pack(fill="both", expand=True)

        self.tree = ttk.Treeview(tree_frame, columns=self.meta["all"],
                                 show="headings", selectmode="browse")
        for col in self.meta["all"]:
            self.tree.heading(col, text=col)
            self.tree.column(col, width=120, anchor="center")
        self.tree.pack(side="left", fill="both", expand=True)

        vsb = ttk.Scrollbar(tree_frame, orient="vertical", command=self.tree.yview)
        vsb.pack(side="right", fill="y")
        self.tree.configure(yscrollcommand=vsb.set)

        self.tree.bind("<<TreeviewSelect>>", self.on_select)

    # ---------------- DB Operations ----------------
    def load_data(self):
        conn = get_connection()
        if not conn:
            return
        try:
            cur = conn.cursor()
            cur.execute(f"SELECT {', '.join(self.meta['all'])} FROM {self.table_name}")
            rows = cur.fetchall()
            self._populate_tree(rows)
        except Exception as e:
            messagebox.showerror("Error", str(e))
        finally:
            conn.close()

    def _populate_tree(self, rows):
        self.tree.delete(*self.tree.get_children())
        for row in rows:
            values = [("" if v is None else v) for v in row]
            self.tree.insert("", "end", values=values)

    def on_select(self, event):
        sel = self.tree.selection()
        if not sel:
            return
        values = self.tree.item(sel[0], "values")
        self.selected_pk = values[0]
        for col, val in zip(self.meta["all"][1:], values[1:]):
            if col in self.entries:
                self.entries[col].delete(0, tk.END)
                self.entries[col].insert(0, val)

    def clear_form(self):
        for e in self.entries.values():
            e.delete(0, tk.END)
        self.selected_pk = None
        if self.tree.selection():
            self.tree.selection_remove(self.tree.selection())

    def _form_values(self):
        data = {}
        for col, entry in self.entries.items():
            v = entry.get().strip()
            data[col] = v if v != "" else None
        return data

    def insert(self):
        data = self._form_values()
        cols = list(data.keys())
        placeholders = ", ".join("?" for _ in cols)
        sql = f"INSERT INTO {self.table_name} ({', '.join(cols)}) VALUES ({placeholders})"
        conn = get_connection()
        if not conn:
            return
        try:
            cur = conn.cursor()
            cur.execute(sql, list(data.values()))
            conn.commit()
            messagebox.showinfo("Success", f"Record inserted into {self.table_name}.")
            self.clear_form()
            self.load_data()
        except Exception as e:
            messagebox.showerror("Insert Error", str(e))
        finally:
            conn.close()

    def update(self):
        if not self.selected_pk:
            messagebox.showwarning("No selection", "Please select a row to update.")
            return
        data = self._form_values()
        set_clause = ", ".join(f"{c} = ?" for c in data.keys())
        sql = f"UPDATE {self.table_name} SET {set_clause} WHERE {self.meta['pk']} = ?"
        conn = get_connection()
        if not conn:
            return
        try:
            cur = conn.cursor()
            cur.execute(sql, list(data.values()) + [self.selected_pk])
            conn.commit()
            messagebox.showinfo("Success", f"Record {self.selected_pk} updated.")
            self.clear_form()
            self.load_data()
        except Exception as e:
            messagebox.showerror("Update Error", str(e))
        finally:
            conn.close()

    def delete(self):
        if not self.selected_pk:
            messagebox.showwarning("No selection", "Please select a row to delete.")
            return
        if not messagebox.askyesno("Confirm", f"Delete record {self.selected_pk}?"):
            return
        sql = f"DELETE FROM {self.table_name} WHERE {self.meta['pk']} = ?"
        conn = get_connection()
        if not conn:
            return
        try:
            cur = conn.cursor()
            cur.execute(sql, self.selected_pk)
            conn.commit()
            messagebox.showinfo("Success", "Record deleted.")
            self.clear_form()
            self.load_data()
        except Exception as e:
            messagebox.showerror("Delete Error", str(e))
        finally:
            conn.close()

    def search(self):
        col = self.search_col.get()
        term = self.search_entry.get().strip()
        if not term:
            self.load_data()
            return
        sql = (f"SELECT {', '.join(self.meta['all'])} FROM {self.table_name} "
               f"WHERE CAST({col} AS NVARCHAR(200)) LIKE ?")
        conn = get_connection()
        if not conn:
            return
        try:
            cur = conn.cursor()
            cur.execute(sql, f"%{term}%")
            self._populate_tree(cur.fetchall())
        except Exception as e:
            messagebox.showerror("Search Error", str(e))
        finally:
            conn.close()

    def export_csv(self):
        path = filedialog.asksaveasfilename(defaultextension=".csv",
                                            filetypes=[("CSV files", "*.csv")],
                                            initialfile=f"{self.table_name}.csv")
        if not path:
            return
        try:
            with open(path, "w", newline="", encoding="utf-8") as f:
                writer = csv.writer(f)
                writer.writerow(self.meta["all"])
                for iid in self.tree.get_children():
                    writer.writerow(self.tree.item(iid, "values"))
            messagebox.showinfo("Exported", f"Saved to {path}")
        except Exception as e:
            messagebox.showerror("Export Error", str(e))


# ---------------------------------------------------------------
# ENTRY POINT
# ---------------------------------------------------------------
if __name__ == "__main__":
    app = DroneApp()
    app.mainloop()