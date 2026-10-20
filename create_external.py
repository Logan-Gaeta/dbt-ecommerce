import duckdb
con = duckdb.connect('dev.duckdb')
con.execute('create schema if not exists external')
con.execute('''create or replace table external.support_tickets as
  select * from (values
    (1, 101, '2026-09-01', 'billing', 'open'),
    (2, 102, '2026-09-02', 'shipping', 'closed'),
    (3, 101, '2026-09-03', 'product', 'open'),
    (4, 103, '2026-09-04', 'billing', 'open'),
    (5, 102, '2026-09-05', 'shipping', 'open')
  ) t(ticket_id, customer_id, created_date, category, status)''')
print('rows:', con.execute('select count(*) from external.support_tickets').fetchone()[0])
con.close()
