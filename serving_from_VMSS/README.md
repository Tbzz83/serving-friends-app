#### Well start by creating two VMs, and imaging them so when can use those images for our VMSS
By this point our code in `friends-app-backend` has been configured to use the MySQL database we've created on Azure. 

This block in `app.py` shows that authentication
```
# >>> SQL DB setup >>>

# Must quote password if it has special characters
sql_pw = quote(CONFIG["sql_pw"])

# If using Azure SQL DB connection string sql_host_db will look like:
sql_host_db = CONFIG["sql_host_db"]
sql_user = CONFIG["sql_user"]
app.config['SQLALCHEMY_DATABASE_URI'] = f"mysql+pymysql://{sql_user}:{sql_pw}@{sql_host_db}"
app.config["SQLALCHEMY_TRACK_MODIFICATIONS"] = False

db = SQLAlchemy(app)

# <<< SQL DB setup <<<
```


