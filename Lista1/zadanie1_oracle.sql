CREATE TABLE Bandy (
    nr_bandy NUMBER(2) CONSTRAINT bandy_pk PRIMARY KEY,
    nazwa VARCHAR2(20) CONSTRAINT bandy_nazwa_nn NOT NULL,
    teren VARCHAR2(15) CONSTRAINT bandy_teren_un UNIQUE,
    szef_bandy VARCHAR2(15) CONSTRAINT bandy_szef_bandy_un UNIQUE
);

CREATE TABLE Funkcje (
    funkcja VARCHAR2(10) CONSTRAINT funkcje_pk PRIMARY KEY,
    min_myszy NUMBER(3) CHECK (min_myszy > 5),
    max_myszy NUMBER(3) CHECK (max_myszy < 200),
    CHECK (max_myszy >= min_myszy)
);

CREATE TABLE Wrogowie (
    imie_wroga VARCHAR2(15) CONSTRAINT wrogowie_pk PRIMARY KEY,
    stopien_wrogosci NUMBER(2) CHECK (stopien_wrogosci BETWEEN 1 AND 10),
    gatunek VARCHAR2(15),
    lapowka VARCHAR2(20)
);

CREATE TABLE Kocury (
    imie VARCHAR2(15) CONSTRAINT kocury_imie_nn NOT NULL,
    plec VARCHAR2(1) CHECK (plec = 'M' OR plec = 'D'),
    pseudo VARCHAR2(15) CONSTRAINT kocury_pk PRIMARY KEY,
    funkcja VARCHAR2(10) CONSTRAINT kocury_funkcja_fk REFERENCES Funkcje(funkcja),
    szef VARCHAR2(15) CONSTRAINT kocury_szef_fk REFERENCES Kocury(pseudo),
    w_stadku_od DATE DEFAULT SYSDATE,
    przydzial_myszy NUMBER(3),
    myszy_extra NUMBER(3),
    nr_bandy NUMBER(2) CONSTRAINT kocury_nr_bandy_fk REFERENCES Bandy(nr_bandy)
);

CREATE TABLE Wrogowie_kocurow (
    pseudo VARCHAR2(15) CONSTRAINT wrogowie_kocurow_pseudo_fk REFERENCES Kocury(pseudo),
    imie_wroga VARCHAR2(15) CONSTRAINT wrogowie_kocurow_imie_wroga_fk REFERENCES Wrogowie(imie_wroga),
    data_incydentu DATE CONSTRAINT wrogowie_kocurow_data_incydentu_nn NOT NULL,
    opis_incydentu VARCHAR2(50),
    CONSTRAINT wrogowie_kocurow_pk PRIMARY KEY (pseudo, imie_wroga)
);

ALTER TABLE Bandy
ADD CONSTRAINT bandy_szef_bandy_fk FOREIGN KEY (szef_bandy) REFERENCES KOCURY(pseudo);