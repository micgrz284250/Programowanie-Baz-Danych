CREATE TABLE Bandy (
    nr_bandy NUMERIC(2) CONSTRAINT bandy_pk PRIMARY KEY,
    nazwa VARCHAR(20) CONSTRAINT bandy_nazwa_nn NOT NULL,
    teren VARCHAR(15) CONSTRAINT bandy_teren_un UNIQUE,
    szef_bandy VARCHAR(15) CONSTRAINT bandy_szef_bandy_un UNIQUE
);

CREATE TABLE Funkcje (
    funkcja VARCHAR(10) CONSTRAINT funkcje_pk PRIMARY KEY,
    min_myszy NUMERIC(3) CHECK (min_myszy > 5),
    max_myszy NUMERIC(3) CHECK (max_myszy < 200),
    CHECK (max_myszy >= min_myszy)
);

CREATE TABLE Wrogowie (
    imie_wroga VARCHAR(15) CONSTRAINT wrogowie_pk PRIMARY KEY,
    stopien_wrogosci NUMERIC(2) CHECK (stopien_wrogosci BETWEEN 1 AND 10),
    gatunek VARCHAR(15),
    lapowka VARCHAR(20)
);

CREATE TABLE Kocury (
    imie VARCHAR(15) CONSTRAINT kocury_imie_nn NOT NULL,
    plec VARCHAR(1) CHECK (plec = 'M' OR plec = 'D'),
    pseudo VARCHAR(15) CONSTRAINT kocury_pk PRIMARY KEY,
    funkcja VARCHAR(10) CONSTRAINT kocury_funkcja_fk REFERENCES Funkcje(funkcja),
    szef VARCHAR(15) CONSTRAINT kocury_szef_fk REFERENCES Kocury(pseudo),
    w_stadku_od DATE DEFAULT current_date,
    przydzial_myszy NUMERIC(3),
    myszy_extra NUMERIC(3),
    nr_bandy NUMERIC(2) CONSTRAINT kocury_nr_bandy_fk REFERENCES Bandy(nr_bandy)
);

CREATE TABLE Wrogowie_kocurow (
    pseudo VARCHAR(15) CONSTRAINT wrogowie_kocurow_pseudo_fk REFERENCES Kocury(pseudo),
    imie_wroga VARCHAR(15) CONSTRAINT wrogowie_kocurow_imie_wroga_fk REFERENCES Wrogowie(imie_wroga),
    data_incydentu DATE CONSTRAINT wrogowie_kocurow_data_incydentu_nn NOT NULL,
    opis_incydentu VARCHAR(50),
    CONSTRAINT wrogowie_kocurow_pk PRIMARY KEY (pseudo, imie_wroga)
);

ALTER TABLE Bandy
ADD CONSTRAINT bandy_szef_bandy_fk FOREIGN KEY (szef_bandy) REFERENCES KOCURY(pseudo);