# Zadanie 1
### 1. Oracle.  
Jako że istnieje wspólna zależność między tabelą Kocury a Bandy niemożliwe było dodania ograniczenia klucza obcego przy tworzeniu tabeli Bandy, należało zmodyfikować tabelę dopiero po utworzeniu tabeli Kocury.

### 2. Postgres.  
Żeby utworzyć tabele należało zmodyfikować skrypt:
- Wszystkie VARCHAR2 należało zmienić na VARCHAR.
- Wszystkie NUMBER należało zmienić na NUMERIC
- SYSDATE należało zastąpić CURRENT_DATE

### 3. Microsoft SQL Server
Żeby utworzyć tabele należało zmodyfikować skrypt:
- Wszystkie VARCHAR2 należało zmienić na VARCHAR.
- Wszystkie NUMBER należało zmienić na NUMERIC
- Należało usunąć constraint przy NOT NULL
- SYSDATE należało zastąpić SYSDATETIME()

# Zadanie 2
### 1. Oracle.  
Wzajemna zależność między tabelą Kocury a Bandy wymagała wyłączenia ograniczenia klucza obcego komendą:
```sql
ALTER TABLE KOCURY DISABLE CONSTRAINT KOCURY_NR_BANDY_FK;
ALTER TABLE KOCURY DISABLE CONSTRAINT KOCURY_SZEF_FK;
```
I włączenia ponownie po wypełnieniu bazy danych komendą:
```sql
ALTER TABLE KOCURY ENABLE CONSTRAINT KOCURY_NR_BANDY_FK;
ALTER TABLE KOCURY ENABLE CONSTRAINT KOCURY_SZEF_FK;
```

### 2. Postgres.  
