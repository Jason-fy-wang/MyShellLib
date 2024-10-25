from ldap3 import Server,Connection, ALL,SUBTREE


server = Server("ldap://192.168.30.15",port=389,get_info=all)

conn = Connection(server=server,user="cn=admin,dc=example,dc=com",password="",auto_bind=True,authentication="SIMPLE")
print("connect success")

conn.search(search_base="dc=example,dc=com",search_filter="(objectClass=*)",search_scope=SUBTREE)


for entry in conn.entries:
    print(entry)