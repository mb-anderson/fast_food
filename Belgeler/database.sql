PGDMP     "    *                z         	   fast_food    13.8    13.8 �    �           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            �           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            �           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            �           1262    49438 	   fast_food    DATABASE     f   CREATE DATABASE fast_food WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE = 'Turkish_Turkey.1254';
    DROP DATABASE fast_food;
                postgres    false            �           1247    49834    cinsiyetler    TYPE     F   CREATE TYPE public.cinsiyetler AS ENUM (
    'Erkek',
    'Kadın'
);
    DROP TYPE public.cinsiyetler;
       public          postgres    false            �            1255    49876    boy_adi_duzenle()    FUNCTION     �   CREATE FUNCTION public.boy_adi_duzenle() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
NEW.boy_ad= INITCAP(NEW.boy_ad);
RETURN NEW;
END;
$$;
 (   DROP FUNCTION public.boy_adi_duzenle();
       public          postgres    false            �            1255    49818    ilce_adi_duzenle()    FUNCTION     �   CREATE FUNCTION public.ilce_adi_duzenle() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
NEW.ilce_ad= INITCAP(NEW.ilce_ad);
RETURN NEW;
END;
$$;
 )   DROP FUNCTION public.ilce_adi_duzenle();
       public          postgres    false            �            1255    49879    kategori_adi_duzenle()    FUNCTION     �   CREATE FUNCTION public.kategori_adi_duzenle() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
NEW.kategori_ad= INITCAP(NEW.kategori_ad);
RETURN NEW;
END;
$$;
 -   DROP FUNCTION public.kategori_adi_duzenle();
       public          postgres    false            �            1255    49441    kdvhesapla(real)    FUNCTION     �   CREATE FUNCTION public.kdvhesapla(fiyat real) RETURNS real
    LANGUAGE plpgsql
    AS $$
	begin 
		fiyat:=fiyat*0.18+fiyat;
		return fiyat;
	end;
$$;
 -   DROP FUNCTION public.kdvhesapla(fiyat real);
       public          postgres    false            �            1255    49882    menu_adi_duzenle()    FUNCTION     �   CREATE FUNCTION public.menu_adi_duzenle() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
NEW.menu_ad= INITCAP(NEW.menu_ad);
RETURN NEW;
END;
$$;
 )   DROP FUNCTION public.menu_adi_duzenle();
       public          postgres    false                       1255    50011    menu_tutar_hesapla()    FUNCTION     �  CREATE FUNCTION public.menu_tutar_hesapla() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
if new.boy = (select boy_id from boylar where boy_ad = 'Büyük') THEN
NEW.tutar = (select fiyat * 1.5  FROM menu where menu_id = NEW.menu);
elseif new.boy = (select boy_id from boylar where boy_ad = 'Orta') THEN
NEW.tutar = (select fiyat * 1.25  FROM menu where menu_id = NEW.menu);
else 
NEW.tutar = (select fiyat * 1  FROM menu where menu_id = NEW.menu);
end if;
RETURN NEW;
END;
$$;
 +   DROP FUNCTION public.menu_tutar_hesapla();
       public          postgres    false            �            1255    49440    menude_ara(character varying)    FUNCTION       CREATE FUNCTION public.menude_ara(v character varying) RETURNS TABLE(id integer, ad character varying, kalori real, fiyat real)
    LANGUAGE plpgsql
    AS $$
	begin 
		return query
		select 
			menü_id,
			menü_ad,
			kalori,
			fiyat
		from menü
			where ad like v;
	end;
$$;
 6   DROP FUNCTION public.menude_ara(v character varying);
       public          postgres    false            �            1255    49439    personel_ad_soyad_duzenle()    FUNCTION     �   CREATE FUNCTION public.personel_ad_soyad_duzenle() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
NEW.ad= INITCAP(NEW.ad);
NEW.soyad= INITCAP(NEW.soyad);
RETURN NEW;
END;
$$;
 2   DROP FUNCTION public.personel_ad_soyad_duzenle();
       public          postgres    false                       1255    50266 "   personel_delete_siparisi_olmayan()    FUNCTION     �   CREATE FUNCTION public.personel_delete_siparisi_olmayan() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
DELETE FROM adres WHERE adres_id = old.adres;
RETURN NEW;
END;
$$;
 9   DROP FUNCTION public.personel_delete_siparisi_olmayan();
       public          postgres    false            �            1255    49442    pr_unvan(character varying) 	   PROCEDURE     �   CREATE PROCEDURE public.pr_unvan(unvan character varying)
    LANGUAGE sql
    AS $$
	insert into unvan values(default,unvan);
$$;
 9   DROP PROCEDURE public.pr_unvan(unvan character varying);
       public          postgres    false            �            1255    49815    sehir_adi_duzenle()    FUNCTION     �   CREATE FUNCTION public.sehir_adi_duzenle() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
NEW.sehir_ad= INITCAP(NEW.sehir_ad);
RETURN NEW;
END;
$$;
 *   DROP FUNCTION public.sehir_adi_duzenle();
       public          postgres    false                        1255    49895    siparis_turu_adi_duzenle()    FUNCTION     �   CREATE FUNCTION public.siparis_turu_adi_duzenle() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
NEW.tur_ad= INITCAP(NEW.tur_ad);
RETURN NEW;
END;
$$;
 1   DROP FUNCTION public.siparis_turu_adi_duzenle();
       public          postgres    false                       1255    58490    siparis_tutar(integer) 	   PROCEDURE       CREATE PROCEDURE public.siparis_tutar(siparisid integer)
    LANGUAGE plpgsql
    AS $$
declare 
menu_tutar real:=0;
urun_tutar real:=0;
menu_tutar_temp real:=0;
urun_tutar_temp real:=0;
begin
    SELECT 
  	SUM(siparis_urun.tutar) into urun_tutar_temp 
	FROM siparis
	LEFT JOIN siparis_urun
	ON siparis.siparis_id = siparis_urun.siparis;
	if urun_tutar_temp > 0 then urun_tutar = urun_tutar_temp;
	else urun_tutar = 0;
	end if;
	SELECT 
  	SUM(siparis_menu.tutar) into menu_tutar_temp 
	FROM siparis
	LEFT JOIN siparis_menu
	ON siparis.siparis_id = siparis_menu.siparis;
	if menu_tutar_temp > 0 then menu_tutar = menu_tutar_temp;
	else  menu_tutar = 0;
	end if;
    update siparis 
    set tutar = public.kdvhesapla(menu_tutar+urun_tutar)
    where siparis_id = siparisid;

end;$$;
 8   DROP PROCEDURE public.siparis_tutar(siparisid integer);
       public          postgres    false                       1255    58495    trg_func_siparis_tutar()    FUNCTION     �   CREATE FUNCTION public.trg_func_siparis_tutar() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
begin
	call public.siparis_tutar(new.siparis);
  RETURN NEW;
end;$$;
 /   DROP FUNCTION public.trg_func_siparis_tutar();
       public          postgres    false                       1255    49929    urun_adi_duzenle()    FUNCTION     �   CREATE FUNCTION public.urun_adi_duzenle() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
NEW.urun_ad= INITCAP(NEW.urun_ad);
RETURN NEW;
END;
$$;
 )   DROP FUNCTION public.urun_adi_duzenle();
       public          postgres    false                       1255    50025    urun_tutar_hesapla()    FUNCTION     �  CREATE FUNCTION public.urun_tutar_hesapla() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
if new.boy = (select boy_id from boylar where boy_ad = 'Büyük') THEN
NEW.tutar = (select fiyat * 1.5  FROM urun where urun_id = NEW.urun);
elseif new.boy = (select boy_id from boylar where boy_ad = 'Orta') THEN
NEW.tutar = (select fiyat * 1.25  FROM urun where urun_id = NEW.urun);
else 
NEW.tutar = (select fiyat * 1  FROM urun where urun_id = NEW.urun);
end if;
RETURN NEW;
END;
$$;
 +   DROP FUNCTION public.urun_tutar_hesapla();
       public          postgres    false            �            1259    49443    adres    TABLE     
  CREATE TABLE public.adres (
    adres_id integer NOT NULL,
    mahalle character varying(20) NOT NULL,
    sokak character varying(20) NOT NULL,
    apartman_no character varying(5) NOT NULL,
    daire_no character varying(5),
    sehir integer,
    ilce integer
);
    DROP TABLE public.adres;
       public         heap    postgres    false            �            1259    49446    adres_adres_id_seq    SEQUENCE     �   CREATE SEQUENCE public.adres_adres_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE public.adres_adres_id_seq;
       public          postgres    false    200            �           0    0    adres_adres_id_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE public.adres_adres_id_seq OWNED BY public.adres.adres_id;
          public          postgres    false    201            �            1259    49784    ilceler    TABLE     }   CREATE TABLE public.ilceler (
    ilce_id integer NOT NULL,
    ilce_ad character varying(50) NOT NULL,
    sehir integer
);
    DROP TABLE public.ilceler;
       public         heap    postgres    false            �            1259    49774    sehirler    TABLE     j   CREATE TABLE public.sehirler (
    plaka integer NOT NULL,
    sehir_ad character varying(50) NOT NULL
);
    DROP TABLE public.sehirler;
       public         heap    postgres    false            �            1259    50269 
   adres_view    VIEW     �  CREATE VIEW public.adres_view AS
 SELECT adres.adres_id,
    adres.mahalle,
    adres.sokak,
    adres.apartman_no,
    adres.daire_no,
    concat(sehirler.sehir_ad, ' ID: ', sehirler.plaka) AS sehir,
    concat(ilceler.ilce_ad, ' ID: ', ilceler.ilce_id) AS ilce
   FROM ((public.adres
     LEFT JOIN public.sehirler ON ((adres.sehir = sehirler.plaka)))
     LEFT JOIN public.ilceler ON ((adres.ilce = ilceler.ilce_id)));
    DROP VIEW public.adres_view;
       public          postgres    false    231    200    200    200    232    232    200    200    200    200    231            �            1259    49860    boylar    TABLE     ^   CREATE TABLE public.boylar (
    boy_id integer NOT NULL,
    boy_ad character varying(10)
);
    DROP TABLE public.boylar;
       public         heap    postgres    false            �            1259    49858    boylar_boy_id_seq    SEQUENCE     �   CREATE SEQUENCE public.boylar_boy_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 (   DROP SEQUENCE public.boylar_boy_id_seq;
       public          postgres    false    236            �           0    0    boylar_boy_id_seq    SEQUENCE OWNED BY     G   ALTER SEQUENCE public.boylar_boy_id_seq OWNED BY public.boylar.boy_id;
          public          postgres    false    235            �            1259    49807    ilceler_ilce_id_seq    SEQUENCE     |   CREATE SEQUENCE public.ilceler_ilce_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 *   DROP SEQUENCE public.ilceler_ilce_id_seq;
       public          postgres    false    232            �           0    0    ilceler_ilce_id_seq    SEQUENCE OWNED BY     K   ALTER SEQUENCE public.ilceler_ilce_id_seq OWNED BY public.ilceler.ilce_id;
          public          postgres    false    233            �            1259    49453    kategori    TABLE     s   CREATE TABLE public.kategori (
    kategori_id integer NOT NULL,
    kategori_ad character varying(40) NOT NULL
);
    DROP TABLE public.kategori;
       public         heap    postgres    false            �            1259    49456    kategori_kategori_id_seq    SEQUENCE     �   CREATE SEQUENCE public.kategori_kategori_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 /   DROP SEQUENCE public.kategori_kategori_id_seq;
       public          postgres    false    202            �           0    0    kategori_kategori_id_seq    SEQUENCE OWNED BY     U   ALTER SEQUENCE public.kategori_kategori_id_seq OWNED BY public.kategori.kategori_id;
          public          postgres    false    203            �            1259    49458    menu    TABLE     �   CREATE TABLE public.menu (
    menu_id integer NOT NULL,
    menu_ad character varying(40) NOT NULL,
    fiyat real NOT NULL
);
    DROP TABLE public.menu;
       public         heap    postgres    false            �            1259    49461    menu_kategori    TABLE     g   CREATE TABLE public.menu_kategori (
    id integer NOT NULL,
    menu integer,
    kategori integer
);
 !   DROP TABLE public.menu_kategori;
       public         heap    postgres    false            �            1259    49468 	   menu_urun    TABLE     _   CREATE TABLE public.menu_urun (
    id integer NOT NULL,
    menu integer,
    urun integer
);
    DROP TABLE public.menu_urun;
       public         heap    postgres    false            �            1259    49464    menü_kategori_id_seq    SEQUENCE     �   CREATE SEQUENCE public."menü_kategori_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 .   DROP SEQUENCE public."menü_kategori_id_seq";
       public          postgres    false    205            �           0    0    menü_kategori_id_seq    SEQUENCE OWNED BY     P   ALTER SEQUENCE public."menü_kategori_id_seq" OWNED BY public.menu_kategori.id;
          public          postgres    false    206            �            1259    49466    menü_menü_id_seq    SEQUENCE     �   CREATE SEQUENCE public."menü_menü_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 +   DROP SEQUENCE public."menü_menü_id_seq";
       public          postgres    false    204            �           0    0    menü_menü_id_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE public."menü_menü_id_seq" OWNED BY public.menu.menu_id;
          public          postgres    false    207            �            1259    49471    menü_ürün_id_seq    SEQUENCE     �   CREATE SEQUENCE public."menü_ürün_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ,   DROP SEQUENCE public."menü_ürün_id_seq";
       public          postgres    false    208            �           0    0    menü_ürün_id_seq    SEQUENCE OWNED BY     J   ALTER SEQUENCE public."menü_ürün_id_seq" OWNED BY public.menu_urun.id;
          public          postgres    false    209            �            1259    49473    musteri    TABLE     5  CREATE TABLE public.musteri (
    musteri_id integer NOT NULL,
    ad character varying(20) NOT NULL,
    soyad character varying(20) NOT NULL,
    telefon character varying(11) NOT NULL,
    email character varying(40),
    adres integer,
    cinsiyet public.cinsiyetler,
    sifre character varying(255)
);
    DROP TABLE public.musteri;
       public         heap    postgres    false    757            �            1259    49476    musteri_musteri_id_seq    SEQUENCE     �   CREATE SEQUENCE public.musteri_musteri_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 -   DROP SEQUENCE public.musteri_musteri_id_seq;
       public          postgres    false    210            �           0    0    musteri_musteri_id_seq    SEQUENCE OWNED BY     Q   ALTER SEQUENCE public.musteri_musteri_id_seq OWNED BY public.musteri.musteri_id;
          public          postgres    false    211            �            1259    50287    musteri_view    VIEW     ;  CREATE VIEW public.musteri_view AS
 SELECT musteri.musteri_id,
    musteri.ad,
    musteri.soyad,
    musteri.telefon,
    musteri.email,
    concat(' ID: ', musteri.adres) AS adres,
    musteri.cinsiyet,
    musteri.sifre
   FROM (public.musteri
     LEFT JOIN public.adres ON ((musteri.adres = adres.adres_id)));
    DROP VIEW public.musteri_view;
       public          postgres    false    210    210    210    210    210    210    210    210    200    757            �            1259    49478    personel    TABLE     �  CREATE TABLE public.personel (
    personel_id integer NOT NULL,
    ad character varying(20) NOT NULL,
    soyad character varying(20) NOT NULL,
    tckimlik character varying(11) NOT NULL,
    telefon character varying(11) NOT NULL,
    email character varying(40),
    maas real,
    ise_giris_tarihi date,
    unvan integer,
    adres integer,
    sube integer,
    cinsiyet public.cinsiyetler DEFAULT 'Erkek'::public.cinsiyetler,
    sifre character varying(255)
);
    DROP TABLE public.personel;
       public         heap    postgres    false    757    757            �            1259    49481    personel_personel_id_seq    SEQUENCE     �   CREATE SEQUENCE public.personel_personel_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 /   DROP SEQUENCE public.personel_personel_id_seq;
       public          postgres    false    212            �           0    0    personel_personel_id_seq    SEQUENCE OWNED BY     U   ALTER SEQUENCE public.personel_personel_id_seq OWNED BY public.personel.personel_id;
          public          postgres    false    213            �            1259    49503    sube    TABLE     �   CREATE TABLE public.sube (
    sube_id integer NOT NULL,
    sube_ad character varying(40),
    telefon character varying(11),
    adres integer
);
    DROP TABLE public.sube;
       public         heap    postgres    false            �            1259    49513    unvan    TABLE     g   CREATE TABLE public.unvan (
    unvan_id integer NOT NULL,
    unvan character varying(20) NOT NULL
);
    DROP TABLE public.unvan;
       public         heap    postgres    false            �            1259    50273    personel_view    VIEW     �  CREATE VIEW public.personel_view AS
 SELECT personel.personel_id,
    personel.ad,
    personel.soyad,
    personel.tckimlik,
    personel.telefon,
    personel.email,
    personel.maas,
    personel.ise_giris_tarihi,
    concat(unvan.unvan, ' ID: ', unvan.unvan_id) AS unvan,
    concat(' ID: ', personel.adres) AS adres,
    concat(sube.sube_ad, ' ID: ', personel.sube) AS sube,
    personel.cinsiyet,
    personel.sifre
   FROM (((public.personel
     LEFT JOIN public.unvan ON ((personel.unvan = unvan.unvan_id)))
     LEFT JOIN public.adres ON ((personel.adres = adres.adres_id)))
     LEFT JOIN public.sube ON ((personel.sube = sube.sube_id)));
     DROP VIEW public.personel_view;
       public          postgres    false    222    212    212    212    212    212    212    212    212    212    220    220    222    200    212    212    212    212    757            �            1259    49483    siparis    TABLE       CREATE TABLE public.siparis (
    siparis_id integer NOT NULL,
    siparis_tarihi timestamp without time zone,
    tutar real,
    musteri integer,
    siparis_durum integer DEFAULT 4,
    personel integer,
    sube integer,
    siparis_turu integer DEFAULT 1
);
    DROP TABLE public.siparis;
       public         heap    postgres    false            �            1259    49498    siparis_durum    TABLE     n   CREATE TABLE public.siparis_durum (
    siparis_durum_id integer NOT NULL,
    durum character varying(40)
);
 !   DROP TABLE public.siparis_durum;
       public         heap    postgres    false            �            1259    49486    siparis_menu    TABLE     �   CREATE TABLE public.siparis_menu (
    id integer NOT NULL,
    menu integer,
    siparis integer,
    boy integer,
    tutar real
);
     DROP TABLE public.siparis_menu;
       public         heap    postgres    false            �            1259    49489    siparis_menu_id_seq    SEQUENCE     �   CREATE SEQUENCE public.siparis_menu_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 *   DROP SEQUENCE public.siparis_menu_id_seq;
       public          postgres    false    215            �           0    0    siparis_menu_id_seq    SEQUENCE OWNED BY     K   ALTER SEQUENCE public.siparis_menu_id_seq OWNED BY public.siparis_menu.id;
          public          postgres    false    216            �            1259    50017    siparis_menu_ve_boy_adi    VIEW     F  CREATE VIEW public.siparis_menu_ve_boy_adi AS
 SELECT siparis_menu.id,
    menu.menu_ad,
    boylar.boy_ad,
    siparis_menu.tutar,
    siparis_menu.siparis
   FROM ((public.siparis_menu
     LEFT JOIN public.menu ON ((siparis_menu.menu = menu.menu_id)))
     LEFT JOIN public.boylar ON ((siparis_menu.boy = boylar.boy_id)));
 *   DROP VIEW public.siparis_menu_ve_boy_adi;
       public          postgres    false    215    204    215    215    215    215    204    236    236            �            1259    49491    siparis_siparis_id_seq    SEQUENCE     �   CREATE SEQUENCE public.siparis_siparis_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 -   DROP SEQUENCE public.siparis_siparis_id_seq;
       public          postgres    false    214            �           0    0    siparis_siparis_id_seq    SEQUENCE OWNED BY     Q   ALTER SEQUENCE public.siparis_siparis_id_seq OWNED BY public.siparis.siparis_id;
          public          postgres    false    217            �            1259    49887    siparis_turleri    TABLE     p   CREATE TABLE public.siparis_turleri (
    tur_id integer NOT NULL,
    tur_ad character varying(20) NOT NULL
);
 #   DROP TABLE public.siparis_turleri;
       public         heap    postgres    false            �            1259    49885    siparis_turleri_tur_id_seq    SEQUENCE     �   CREATE SEQUENCE public.siparis_turleri_tur_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 1   DROP SEQUENCE public.siparis_turleri_tur_id_seq;
       public          postgres    false    238                        0    0    siparis_turleri_tur_id_seq    SEQUENCE OWNED BY     Y   ALTER SEQUENCE public.siparis_turleri_tur_id_seq OWNED BY public.siparis_turleri.tur_id;
          public          postgres    false    237            �            1259    49911    siparis_urun    TABLE     �   CREATE TABLE public.siparis_urun (
    id integer NOT NULL,
    siparis integer,
    urun integer,
    boy integer,
    tutar real
);
     DROP TABLE public.siparis_urun;
       public         heap    postgres    false            �            1259    49909    siparis_urun_id_seq    SEQUENCE     �   CREATE SEQUENCE public.siparis_urun_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 *   DROP SEQUENCE public.siparis_urun_id_seq;
       public          postgres    false    240                       0    0    siparis_urun_id_seq    SEQUENCE OWNED BY     K   ALTER SEQUENCE public.siparis_urun_id_seq OWNED BY public.siparis_urun.id;
          public          postgres    false    239            �            1259    49542    urun    TABLE     �   CREATE TABLE public.urun (
    urun_id integer NOT NULL,
    urun_ad character varying(40) NOT NULL,
    fiyat real NOT NULL
);
    DROP TABLE public.urun;
       public         heap    postgres    false            �            1259    50021    siparis_urun_ve_boy_adi    VIEW     F  CREATE VIEW public.siparis_urun_ve_boy_adi AS
 SELECT siparis_urun.id,
    urun.urun_ad,
    boylar.boy_ad,
    siparis_urun.tutar,
    siparis_urun.siparis
   FROM ((public.siparis_urun
     LEFT JOIN public.urun ON ((siparis_urun.urun = urun.urun_id)))
     LEFT JOIN public.boylar ON ((siparis_urun.boy = boylar.boy_id)));
 *   DROP VIEW public.siparis_urun_ve_boy_adi;
       public          postgres    false    240    240    240    240    236    236    226    226    240            �            1259    50049    siparis_view    VIEW     �  CREATE VIEW public.siparis_view AS
 SELECT siparis.siparis_id,
    siparis.siparis_tarihi,
    siparis.tutar,
    siparis.musteri,
    concat(siparis_durum.durum, ' ID: ', siparis.siparis_durum) AS siparis_durumu,
    concat(personel.ad, ' ', personel.soyad, ' ID: ', personel.personel_id) AS personel,
    concat(sube.sube_ad, ' ID: ', sube.sube_id) AS sube,
    siparis_turleri.tur_ad
   FROM ((((public.siparis
     LEFT JOIN public.siparis_durum ON ((siparis.siparis_durum = siparis_durum.siparis_durum_id)))
     LEFT JOIN public.siparis_turleri ON ((siparis.siparis_turu = siparis_turleri.tur_id)))
     LEFT JOIN public.personel ON ((siparis.personel = personel.personel_id)))
     LEFT JOIN public.sube ON ((siparis.sube = sube.sube_id)));
    DROP VIEW public.siparis_view;
       public          postgres    false    214    238    238    220    220    218    218    214    214    214    214    214    214    214    212    212    212            �            1259    49501 !   siparisdurum_siparis_durum_id_seq    SEQUENCE     �   CREATE SEQUENCE public.siparisdurum_siparis_durum_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 8   DROP SEQUENCE public.siparisdurum_siparis_durum_id_seq;
       public          postgres    false    218                       0    0 !   siparisdurum_siparis_durum_id_seq    SEQUENCE OWNED BY     h   ALTER SEQUENCE public.siparisdurum_siparis_durum_id_seq OWNED BY public.siparis_durum.siparis_durum_id;
          public          postgres    false    219            �            1259    49511    sube_sube_id_seq    SEQUENCE     �   CREATE SEQUENCE public.sube_sube_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 '   DROP SEQUENCE public.sube_sube_id_seq;
       public          postgres    false    220                       0    0    sube_sube_id_seq    SEQUENCE OWNED BY     E   ALTER SEQUENCE public.sube_sube_id_seq OWNED BY public.sube.sube_id;
          public          postgres    false    221            �            1259    49516    unvan_unvan_id_seq    SEQUENCE     �   CREATE SEQUENCE public.unvan_unvan_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE public.unvan_unvan_id_seq;
       public          postgres    false    222                       0    0    unvan_unvan_id_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE public.unvan_unvan_id_seq OWNED BY public.unvan.unvan_id;
          public          postgres    false    223            �            1259    49545    urun_kategori    TABLE     g   CREATE TABLE public.urun_kategori (
    id integer NOT NULL,
    kategori integer,
    urun integer
);
 !   DROP TABLE public.urun_kategori;
       public         heap    postgres    false            �            1259    49839    vw_cinsiyet    VIEW     P  CREATE VIEW public.vw_cinsiyet AS
 SELECT sum(
        CASE personel.cinsiyet
            WHEN 'Erkek'::public.cinsiyetler THEN 1
            ELSE 0
        END) AS "Erkek",
    sum(
        CASE personel.cinsiyet
            WHEN 'Kadın'::public.cinsiyetler THEN 1
            ELSE 0
        END) AS "Kadın"
   FROM public.personel;
    DROP VIEW public.vw_cinsiyet;
       public          postgres    false    757    212            �            1259    49769    vw_personel_sube    VIEW     ,  CREATE VIEW public.vw_personel_sube AS
 SELECT p.ad,
    p.soyad,
    p.maas,
    sube.sube_ad,
    sube.telefon,
    adres.adres_id
   FROM ((public.personel p
     JOIN public.sube ON ((sube.sube_id = p.personel_id)))
     JOIN public.adres ON ((adres.adres_id = sube.sube_id)))
  ORDER BY p.maas;
 #   DROP VIEW public.vw_personel_sube;
       public          postgres    false    212    212    212    212    220    220    220    200            �            1259    49532    vw_personel_unvan    VIEW       CREATE VIEW public.vw_personel_unvan AS
 SELECT p.ad AS personelad,
    p.soyad AS personelsoyad,
        CASE
            WHEN (p.unvan = 1) THEN 'Kasiyer'::text
            WHEN (p.unvan = 2) THEN 'Asçı'::text
            WHEN (p.unvan = 3) THEN 'Aşcı yardımcısı'::text
            WHEN (p.unvan = 4) THEN 'Temizlik elemanı'::text
            WHEN (p.unvan > 4) THEN 'Diğer'::text
            ELSE NULL::text
        END AS pozisyon
   FROM (public.personel p
     JOIN public.unvan u ON ((u.unvan_id = p.unvan)))
  ORDER BY p.ad;
 $   DROP VIEW public.vw_personel_unvan;
       public          postgres    false    222    212    212    212            �            1259    49537    vw_personel_unvan_sube    VIEW     f  CREATE VIEW public.vw_personel_unvan_sube AS
 SELECT p.ad AS personelad,
    p.soyad AS personelsoyad,
    s.sube_ad,
        CASE
            WHEN (p.unvan = 1) THEN 'Kasiyer'::text
            WHEN (p.unvan = 2) THEN 'Asçı'::text
            WHEN (p.unvan = 3) THEN 'Aşcı yardımcısı'::text
            WHEN (p.unvan = 4) THEN 'Temizlik elemanı'::text
            WHEN (p.unvan > 4) THEN 'Diğer'::text
            ELSE NULL::text
        END AS pozisyon
   FROM ((public.personel p
     JOIN public.unvan u ON ((u.unvan_id = p.unvan)))
     JOIN public.sube s ON ((s.sube_id = p.sube)))
  ORDER BY p.ad;
 )   DROP VIEW public.vw_personel_unvan_sube;
       public          postgres    false    212    222    220    220    212    212    212            �            1259    49548    ürün_kategori_id_seq    SEQUENCE     �   CREATE SEQUENCE public."ürün_kategori_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 /   DROP SEQUENCE public."ürün_kategori_id_seq";
       public          postgres    false    227                       0    0    ürün_kategori_id_seq    SEQUENCE OWNED BY     Q   ALTER SEQUENCE public."ürün_kategori_id_seq" OWNED BY public.urun_kategori.id;
          public          postgres    false    228            �            1259    49550    ürün_ürün_id_seq    SEQUENCE     �   CREATE SEQUENCE public."ürün_ürün_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 -   DROP SEQUENCE public."ürün_ürün_id_seq";
       public          postgres    false    226                       0    0    ürün_ürün_id_seq    SEQUENCE OWNED BY     K   ALTER SEQUENCE public."ürün_ürün_id_seq" OWNED BY public.urun.urun_id;
          public          postgres    false    229            �           2604    49552    adres adres_id    DEFAULT     p   ALTER TABLE ONLY public.adres ALTER COLUMN adres_id SET DEFAULT nextval('public.adres_adres_id_seq'::regclass);
 =   ALTER TABLE public.adres ALTER COLUMN adres_id DROP DEFAULT;
       public          postgres    false    201    200            �           2604    49863    boylar boy_id    DEFAULT     n   ALTER TABLE ONLY public.boylar ALTER COLUMN boy_id SET DEFAULT nextval('public.boylar_boy_id_seq'::regclass);
 <   ALTER TABLE public.boylar ALTER COLUMN boy_id DROP DEFAULT;
       public          postgres    false    236    235    236            �           2604    49809    ilceler ilce_id    DEFAULT     r   ALTER TABLE ONLY public.ilceler ALTER COLUMN ilce_id SET DEFAULT nextval('public.ilceler_ilce_id_seq'::regclass);
 >   ALTER TABLE public.ilceler ALTER COLUMN ilce_id DROP DEFAULT;
       public          postgres    false    233    232            �           2604    49554    kategori kategori_id    DEFAULT     |   ALTER TABLE ONLY public.kategori ALTER COLUMN kategori_id SET DEFAULT nextval('public.kategori_kategori_id_seq'::regclass);
 C   ALTER TABLE public.kategori ALTER COLUMN kategori_id DROP DEFAULT;
       public          postgres    false    203    202            �           2604    49555    menu menu_id    DEFAULT     p   ALTER TABLE ONLY public.menu ALTER COLUMN menu_id SET DEFAULT nextval('public."menü_menü_id_seq"'::regclass);
 ;   ALTER TABLE public.menu ALTER COLUMN menu_id DROP DEFAULT;
       public          postgres    false    207    204            �           2604    49556    menu_kategori id    DEFAULT     w   ALTER TABLE ONLY public.menu_kategori ALTER COLUMN id SET DEFAULT nextval('public."menü_kategori_id_seq"'::regclass);
 ?   ALTER TABLE public.menu_kategori ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    206    205            �           2604    49557    menu_urun id    DEFAULT     q   ALTER TABLE ONLY public.menu_urun ALTER COLUMN id SET DEFAULT nextval('public."menü_ürün_id_seq"'::regclass);
 ;   ALTER TABLE public.menu_urun ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    209    208            �           2604    49558    musteri musteri_id    DEFAULT     x   ALTER TABLE ONLY public.musteri ALTER COLUMN musteri_id SET DEFAULT nextval('public.musteri_musteri_id_seq'::regclass);
 A   ALTER TABLE public.musteri ALTER COLUMN musteri_id DROP DEFAULT;
       public          postgres    false    211    210            �           2604    49559    personel personel_id    DEFAULT     |   ALTER TABLE ONLY public.personel ALTER COLUMN personel_id SET DEFAULT nextval('public.personel_personel_id_seq'::regclass);
 C   ALTER TABLE public.personel ALTER COLUMN personel_id DROP DEFAULT;
       public          postgres    false    213    212            �           2604    49560    siparis siparis_id    DEFAULT     x   ALTER TABLE ONLY public.siparis ALTER COLUMN siparis_id SET DEFAULT nextval('public.siparis_siparis_id_seq'::regclass);
 A   ALTER TABLE public.siparis ALTER COLUMN siparis_id DROP DEFAULT;
       public          postgres    false    217    214            �           2604    49563    siparis_durum siparis_durum_id    DEFAULT     �   ALTER TABLE ONLY public.siparis_durum ALTER COLUMN siparis_durum_id SET DEFAULT nextval('public.siparisdurum_siparis_durum_id_seq'::regclass);
 M   ALTER TABLE public.siparis_durum ALTER COLUMN siparis_durum_id DROP DEFAULT;
       public          postgres    false    219    218            �           2604    49561    siparis_menu id    DEFAULT     r   ALTER TABLE ONLY public.siparis_menu ALTER COLUMN id SET DEFAULT nextval('public.siparis_menu_id_seq'::regclass);
 >   ALTER TABLE public.siparis_menu ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    216    215            �           2604    49890    siparis_turleri tur_id    DEFAULT     �   ALTER TABLE ONLY public.siparis_turleri ALTER COLUMN tur_id SET DEFAULT nextval('public.siparis_turleri_tur_id_seq'::regclass);
 E   ALTER TABLE public.siparis_turleri ALTER COLUMN tur_id DROP DEFAULT;
       public          postgres    false    237    238    238            �           2604    49914    siparis_urun id    DEFAULT     r   ALTER TABLE ONLY public.siparis_urun ALTER COLUMN id SET DEFAULT nextval('public.siparis_urun_id_seq'::regclass);
 >   ALTER TABLE public.siparis_urun ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    240    239    240            �           2604    49564    sube sube_id    DEFAULT     l   ALTER TABLE ONLY public.sube ALTER COLUMN sube_id SET DEFAULT nextval('public.sube_sube_id_seq'::regclass);
 ;   ALTER TABLE public.sube ALTER COLUMN sube_id DROP DEFAULT;
       public          postgres    false    221    220            �           2604    49566    unvan unvan_id    DEFAULT     p   ALTER TABLE ONLY public.unvan ALTER COLUMN unvan_id SET DEFAULT nextval('public.unvan_unvan_id_seq'::regclass);
 =   ALTER TABLE public.unvan ALTER COLUMN unvan_id DROP DEFAULT;
       public          postgres    false    223    222            �           2604    49567    urun urun_id    DEFAULT     r   ALTER TABLE ONLY public.urun ALTER COLUMN urun_id SET DEFAULT nextval('public."ürün_ürün_id_seq"'::regclass);
 ;   ALTER TABLE public.urun ALTER COLUMN urun_id DROP DEFAULT;
       public          postgres    false    229    226            �           2604    49568    urun_kategori id    DEFAULT     x   ALTER TABLE ONLY public.urun_kategori ALTER COLUMN id SET DEFAULT nextval('public."ürün_kategori_id_seq"'::regclass);
 ?   ALTER TABLE public.urun_kategori ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    228    227            �          0    49443    adres 
   TABLE DATA           ]   COPY public.adres (adres_id, mahalle, sokak, apartman_no, daire_no, sehir, ilce) FROM stdin;
    public          postgres    false    200   �      �          0    49860    boylar 
   TABLE DATA           0   COPY public.boylar (boy_id, boy_ad) FROM stdin;
    public          postgres    false    236   �      �          0    49784    ilceler 
   TABLE DATA           :   COPY public.ilceler (ilce_id, ilce_ad, sehir) FROM stdin;
    public          postgres    false    232   %      �          0    49453    kategori 
   TABLE DATA           <   COPY public.kategori (kategori_id, kategori_ad) FROM stdin;
    public          postgres    false    202   �3      �          0    49458    menu 
   TABLE DATA           7   COPY public.menu (menu_id, menu_ad, fiyat) FROM stdin;
    public          postgres    false    204   4      �          0    49461    menu_kategori 
   TABLE DATA           ;   COPY public.menu_kategori (id, menu, kategori) FROM stdin;
    public          postgres    false    205   �4      �          0    49468 	   menu_urun 
   TABLE DATA           3   COPY public.menu_urun (id, menu, urun) FROM stdin;
    public          postgres    false    208   )5      �          0    49473    musteri 
   TABLE DATA           `   COPY public.musteri (musteri_id, ad, soyad, telefon, email, adres, cinsiyet, sifre) FROM stdin;
    public          postgres    false    210   m5      �          0    49478    personel 
   TABLE DATA           �   COPY public.personel (personel_id, ad, soyad, tckimlik, telefon, email, maas, ise_giris_tarihi, unvan, adres, sube, cinsiyet, sifre) FROM stdin;
    public          postgres    false    212   �6      �          0    49774    sehirler 
   TABLE DATA           3   COPY public.sehirler (plaka, sehir_ad) FROM stdin;
    public          postgres    false    231   9      �          0    49483    siparis 
   TABLE DATA           z   COPY public.siparis (siparis_id, siparis_tarihi, tutar, musteri, siparis_durum, personel, sube, siparis_turu) FROM stdin;
    public          postgres    false    214   �;      �          0    49498    siparis_durum 
   TABLE DATA           @   COPY public.siparis_durum (siparis_durum_id, durum) FROM stdin;
    public          postgres    false    218   �;      �          0    49486    siparis_menu 
   TABLE DATA           E   COPY public.siparis_menu (id, menu, siparis, boy, tutar) FROM stdin;
    public          postgres    false    215   <      �          0    49887    siparis_turleri 
   TABLE DATA           9   COPY public.siparis_turleri (tur_id, tur_ad) FROM stdin;
    public          postgres    false    238   G<      �          0    49911    siparis_urun 
   TABLE DATA           E   COPY public.siparis_urun (id, siparis, urun, boy, tutar) FROM stdin;
    public          postgres    false    240   �<      �          0    49503    sube 
   TABLE DATA           @   COPY public.sube (sube_id, sube_ad, telefon, adres) FROM stdin;
    public          postgres    false    220   �<      �          0    49513    unvan 
   TABLE DATA           0   COPY public.unvan (unvan_id, unvan) FROM stdin;
    public          postgres    false    222   O=      �          0    49542    urun 
   TABLE DATA           7   COPY public.urun (urun_id, urun_ad, fiyat) FROM stdin;
    public          postgres    false    226   �=      �          0    49545    urun_kategori 
   TABLE DATA           ;   COPY public.urun_kategori (id, kategori, urun) FROM stdin;
    public          postgres    false    227   �>                 0    0    adres_adres_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.adres_adres_id_seq', 82, true);
          public          postgres    false    201                       0    0    boylar_boy_id_seq    SEQUENCE SET     ?   SELECT pg_catalog.setval('public.boylar_boy_id_seq', 9, true);
          public          postgres    false    235            	           0    0    ilceler_ilce_id_seq    SEQUENCE SET     D   SELECT pg_catalog.setval('public.ilceler_ilce_id_seq', 1824, true);
          public          postgres    false    233            
           0    0    kategori_kategori_id_seq    SEQUENCE SET     G   SELECT pg_catalog.setval('public.kategori_kategori_id_seq', 16, true);
          public          postgres    false    203                       0    0    menü_kategori_id_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('public."menü_kategori_id_seq"', 10, true);
          public          postgres    false    206                       0    0    menü_menü_id_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('public."menü_menü_id_seq"', 15, true);
          public          postgres    false    207                       0    0    menü_ürün_id_seq    SEQUENCE SET     D   SELECT pg_catalog.setval('public."menü_ürün_id_seq"', 10, true);
          public          postgres    false    209                       0    0    musteri_musteri_id_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public.musteri_musteri_id_seq', 13, true);
          public          postgres    false    211                       0    0    personel_personel_id_seq    SEQUENCE SET     G   SELECT pg_catalog.setval('public.personel_personel_id_seq', 26, true);
          public          postgres    false    213                       0    0    siparis_menu_id_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('public.siparis_menu_id_seq', 51, true);
          public          postgres    false    216                       0    0    siparis_siparis_id_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public.siparis_siparis_id_seq', 34, true);
          public          postgres    false    217                       0    0    siparis_turleri_tur_id_seq    SEQUENCE SET     H   SELECT pg_catalog.setval('public.siparis_turleri_tur_id_seq', 3, true);
          public          postgres    false    237                       0    0    siparis_urun_id_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('public.siparis_urun_id_seq', 46, true);
          public          postgres    false    239                       0    0 !   siparisdurum_siparis_durum_id_seq    SEQUENCE SET     O   SELECT pg_catalog.setval('public.siparisdurum_siparis_durum_id_seq', 5, true);
          public          postgres    false    219                       0    0    sube_sube_id_seq    SEQUENCE SET     ?   SELECT pg_catalog.setval('public.sube_sube_id_seq', 13, true);
          public          postgres    false    221                       0    0    unvan_unvan_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.unvan_unvan_id_seq', 11, true);
          public          postgres    false    223                       0    0    ürün_kategori_id_seq    SEQUENCE SET     G   SELECT pg_catalog.setval('public."ürün_kategori_id_seq"', 10, true);
          public          postgres    false    228                       0    0    ürün_ürün_id_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public."ürün_ürün_id_seq"', 13, true);
          public          postgres    false    229            �           2606    49570    adres adres_pkey 
   CONSTRAINT     T   ALTER TABLE ONLY public.adres
    ADD CONSTRAINT adres_pkey PRIMARY KEY (adres_id);
 :   ALTER TABLE ONLY public.adres DROP CONSTRAINT adres_pkey;
       public            postgres    false    200                       2606    49872    boylar boylar_boy_ad_key 
   CONSTRAINT     U   ALTER TABLE ONLY public.boylar
    ADD CONSTRAINT boylar_boy_ad_key UNIQUE (boy_ad);
 B   ALTER TABLE ONLY public.boylar DROP CONSTRAINT boylar_boy_ad_key;
       public            postgres    false    236            	           2606    49865    boylar boylar_pkey 
   CONSTRAINT     T   ALTER TABLE ONLY public.boylar
    ADD CONSTRAINT boylar_pkey PRIMARY KEY (boy_id);
 <   ALTER TABLE ONLY public.boylar DROP CONSTRAINT boylar_pkey;
       public            postgres    false    236                       2606    49788    ilceler ilceler_pkey 
   CONSTRAINT     W   ALTER TABLE ONLY public.ilceler
    ADD CONSTRAINT ilceler_pkey PRIMARY KEY (ilce_id);
 >   ALTER TABLE ONLY public.ilceler DROP CONSTRAINT ilceler_pkey;
       public            postgres    false    232            �           2606    49574    kategori kategori_pkey 
   CONSTRAINT     ]   ALTER TABLE ONLY public.kategori
    ADD CONSTRAINT kategori_pkey PRIMARY KEY (kategori_id);
 @   ALTER TABLE ONLY public.kategori DROP CONSTRAINT kategori_pkey;
       public            postgres    false    202            �           2606    49852 -   menu_kategori menu_kategori_menu_kategori_key 
   CONSTRAINT     r   ALTER TABLE ONLY public.menu_kategori
    ADD CONSTRAINT menu_kategori_menu_kategori_key UNIQUE (menu, kategori);
 W   ALTER TABLE ONLY public.menu_kategori DROP CONSTRAINT menu_kategori_menu_kategori_key;
       public            postgres    false    205    205            �           2606    49578    menu menu_pkey 
   CONSTRAINT     Q   ALTER TABLE ONLY public.menu
    ADD CONSTRAINT menu_pkey PRIMARY KEY (menu_id);
 8   ALTER TABLE ONLY public.menu DROP CONSTRAINT menu_pkey;
       public            postgres    false    204            �           2606    49580    menu_urun menu_urun_pkey 
   CONSTRAINT     V   ALTER TABLE ONLY public.menu_urun
    ADD CONSTRAINT menu_urun_pkey PRIMARY KEY (id);
 B   ALTER TABLE ONLY public.menu_urun DROP CONSTRAINT menu_urun_pkey;
       public            postgres    false    208            �           2606    49576 !   menu_kategori menü_kategori_pkey 
   CONSTRAINT     a   ALTER TABLE ONLY public.menu_kategori
    ADD CONSTRAINT "menü_kategori_pkey" PRIMARY KEY (id);
 M   ALTER TABLE ONLY public.menu_kategori DROP CONSTRAINT "menü_kategori_pkey";
       public            postgres    false    205            �           2606    49584    musteri musteri_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY public.musteri
    ADD CONSTRAINT musteri_pkey PRIMARY KEY (musteri_id);
 >   ALTER TABLE ONLY public.musteri DROP CONSTRAINT musteri_pkey;
       public            postgres    false    210            �           2606    49590    personel personel_pkey 
   CONSTRAINT     ]   ALTER TABLE ONLY public.personel
    ADD CONSTRAINT personel_pkey PRIMARY KEY (personel_id);
 @   ALTER TABLE ONLY public.personel DROP CONSTRAINT personel_pkey;
       public            postgres    false    212                       2606    49778    sehirler sehirler_pkey 
   CONSTRAINT     W   ALTER TABLE ONLY public.sehirler
    ADD CONSTRAINT sehirler_pkey PRIMARY KEY (plaka);
 @   ALTER TABLE ONLY public.sehirler DROP CONSTRAINT sehirler_pkey;
       public            postgres    false    231            �           2606    49844 %   siparis_durum siparis_durum_durum_key 
   CONSTRAINT     a   ALTER TABLE ONLY public.siparis_durum
    ADD CONSTRAINT siparis_durum_durum_key UNIQUE (durum);
 O   ALTER TABLE ONLY public.siparis_durum DROP CONSTRAINT siparis_durum_durum_key;
       public            postgres    false    218            �           2606    49602     siparis_durum siparis_durum_pkey 
   CONSTRAINT     l   ALTER TABLE ONLY public.siparis_durum
    ADD CONSTRAINT siparis_durum_pkey PRIMARY KEY (siparis_durum_id);
 J   ALTER TABLE ONLY public.siparis_durum DROP CONSTRAINT siparis_durum_pkey;
       public            postgres    false    218            �           2606    49596    siparis_menu siparis_menu_pkey 
   CONSTRAINT     \   ALTER TABLE ONLY public.siparis_menu
    ADD CONSTRAINT siparis_menu_pkey PRIMARY KEY (id);
 H   ALTER TABLE ONLY public.siparis_menu DROP CONSTRAINT siparis_menu_pkey;
       public            postgres    false    215            �           2606    49598    siparis siparis_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY public.siparis
    ADD CONSTRAINT siparis_pkey PRIMARY KEY (siparis_id);
 >   ALTER TABLE ONLY public.siparis DROP CONSTRAINT siparis_pkey;
       public            postgres    false    214                       2606    49892 $   siparis_turleri siparis_turleri_pkey 
   CONSTRAINT     f   ALTER TABLE ONLY public.siparis_turleri
    ADD CONSTRAINT siparis_turleri_pkey PRIMARY KEY (tur_id);
 N   ALTER TABLE ONLY public.siparis_turleri DROP CONSTRAINT siparis_turleri_pkey;
       public            postgres    false    238                       2606    49894 *   siparis_turleri siparis_turleri_tur_ad_key 
   CONSTRAINT     g   ALTER TABLE ONLY public.siparis_turleri
    ADD CONSTRAINT siparis_turleri_tur_ad_key UNIQUE (tur_ad);
 T   ALTER TABLE ONLY public.siparis_turleri DROP CONSTRAINT siparis_turleri_tur_ad_key;
       public            postgres    false    238                       2606    49916    siparis_urun siparis_urun_pkey 
   CONSTRAINT     \   ALTER TABLE ONLY public.siparis_urun
    ADD CONSTRAINT siparis_urun_pkey PRIMARY KEY (id);
 H   ALTER TABLE ONLY public.siparis_urun DROP CONSTRAINT siparis_urun_pkey;
       public            postgres    false    240            �           2606    49846    sube sube_adres_key 
   CONSTRAINT     O   ALTER TABLE ONLY public.sube
    ADD CONSTRAINT sube_adres_key UNIQUE (adres);
 =   ALTER TABLE ONLY public.sube DROP CONSTRAINT sube_adres_key;
       public            postgres    false    220            �           2606    49606    sube sube_pkey 
   CONSTRAINT     Q   ALTER TABLE ONLY public.sube
    ADD CONSTRAINT sube_pkey PRIMARY KEY (sube_id);
 8   ALTER TABLE ONLY public.sube DROP CONSTRAINT sube_pkey;
       public            postgres    false    220            �           2606    49763    sube sube_telefon_key 
   CONSTRAINT     S   ALTER TABLE ONLY public.sube
    ADD CONSTRAINT sube_telefon_key UNIQUE (telefon);
 ?   ALTER TABLE ONLY public.sube DROP CONSTRAINT sube_telefon_key;
       public            postgres    false    220            �           2606    49610    unvan unvan_pkey 
   CONSTRAINT     T   ALTER TABLE ONLY public.unvan
    ADD CONSTRAINT unvan_pkey PRIMARY KEY (unvan_id);
 :   ALTER TABLE ONLY public.unvan DROP CONSTRAINT unvan_pkey;
       public            postgres    false    222            �           2606    49848    unvan unvan_unvan_key 
   CONSTRAINT     Q   ALTER TABLE ONLY public.unvan
    ADD CONSTRAINT unvan_unvan_key UNIQUE (unvan);
 ?   ALTER TABLE ONLY public.unvan DROP CONSTRAINT unvan_unvan_key;
       public            postgres    false    222                       2606    49612     urun_kategori urun_kategori_pkey 
   CONSTRAINT     ^   ALTER TABLE ONLY public.urun_kategori
    ADD CONSTRAINT urun_kategori_pkey PRIMARY KEY (id);
 J   ALTER TABLE ONLY public.urun_kategori DROP CONSTRAINT urun_kategori_pkey;
       public            postgres    false    227            �           2606    49614    urun urun_pkey 
   CONSTRAINT     Q   ALTER TABLE ONLY public.urun
    ADD CONSTRAINT urun_pkey PRIMARY KEY (urun_id);
 8   ALTER TABLE ONLY public.urun DROP CONSTRAINT urun_pkey;
       public            postgres    false    226            /           2620    50268 "   personel trg_after_delete_personel    TRIGGER     �   CREATE TRIGGER trg_after_delete_personel AFTER DELETE ON public.personel FOR EACH ROW EXECUTE FUNCTION public.personel_delete_siparisi_olmayan();
 ;   DROP TRIGGER trg_after_delete_personel ON public.personel;
       public          postgres    false    212    258            1           2620    58496 *   siparis_menu trg_after_insert_siparis_menu    TRIGGER     �   CREATE TRIGGER trg_after_insert_siparis_menu AFTER INSERT ON public.siparis_menu FOR EACH ROW EXECUTE FUNCTION public.trg_func_siparis_tutar();
 C   DROP TRIGGER trg_after_insert_siparis_menu ON public.siparis_menu;
       public          postgres    false    272    215            <           2620    58498 *   siparis_urun trg_after_insert_siparis_urun    TRIGGER     �   CREATE TRIGGER trg_after_insert_siparis_urun AFTER INSERT ON public.siparis_urun FOR EACH ROW EXECUTE FUNCTION public.trg_func_siparis_tutar();
 C   DROP TRIGGER trg_after_insert_siparis_urun ON public.siparis_urun;
       public          postgres    false    240    272            8           2620    49878    boylar trg_before_insert_boylar    TRIGGER        CREATE TRIGGER trg_before_insert_boylar BEFORE INSERT ON public.boylar FOR EACH ROW EXECUTE FUNCTION public.boy_adi_duzenle();
 8   DROP TRIGGER trg_before_insert_boylar ON public.boylar;
       public          postgres    false    236    253            6           2620    49820    ilceler trg_before_insert_ilce    TRIGGER        CREATE TRIGGER trg_before_insert_ilce BEFORE INSERT ON public.ilceler FOR EACH ROW EXECUTE FUNCTION public.ilce_adi_duzenle();
 7   DROP TRIGGER trg_before_insert_ilce ON public.ilceler;
       public          postgres    false    252    232            )           2620    49880 #   kategori trg_before_insert_kategori    TRIGGER     �   CREATE TRIGGER trg_before_insert_kategori BEFORE INSERT ON public.kategori FOR EACH ROW EXECUTE FUNCTION public.kategori_adi_duzenle();
 <   DROP TRIGGER trg_before_insert_kategori ON public.kategori;
       public          postgres    false    202    254            ,           2620    49884    menu trg_before_insert_menu    TRIGGER     |   CREATE TRIGGER trg_before_insert_menu BEFORE INSERT ON public.menu FOR EACH ROW EXECUTE FUNCTION public.menu_adi_duzenle();
 4   DROP TRIGGER trg_before_insert_menu ON public.menu;
       public          postgres    false    204    255            -           2620    49873 #   personel trg_before_insert_personel    TRIGGER     �   CREATE TRIGGER trg_before_insert_personel BEFORE INSERT ON public.personel FOR EACH ROW EXECUTE FUNCTION public.personel_ad_soyad_duzenle();
 <   DROP TRIGGER trg_before_insert_personel ON public.personel;
       public          postgres    false    247    212            5           2620    49816     sehirler trg_before_insert_sehir    TRIGGER     �   CREATE TRIGGER trg_before_insert_sehir BEFORE INSERT ON public.sehirler FOR EACH ROW EXECUTE FUNCTION public.sehir_adi_duzenle();
 9   DROP TRIGGER trg_before_insert_sehir ON public.sehirler;
       public          postgres    false    231    251            0           2620    50012 +   siparis_menu trg_before_insert_siparis_menu    TRIGGER     �   CREATE TRIGGER trg_before_insert_siparis_menu BEFORE INSERT ON public.siparis_menu FOR EACH ROW EXECUTE FUNCTION public.menu_tutar_hesapla();
 D   DROP TRIGGER trg_before_insert_siparis_menu ON public.siparis_menu;
       public          postgres    false    271    215            ;           2620    49896 1   siparis_turleri trg_before_insert_siparis_turleri    TRIGGER     �   CREATE TRIGGER trg_before_insert_siparis_turleri BEFORE INSERT ON public.siparis_turleri FOR EACH ROW EXECUTE FUNCTION public.siparis_turu_adi_duzenle();
 J   DROP TRIGGER trg_before_insert_siparis_turleri ON public.siparis_turleri;
       public          postgres    false    238    256            =           2620    50026 +   siparis_urun trg_before_insert_siparis_urun    TRIGGER     �   CREATE TRIGGER trg_before_insert_siparis_urun BEFORE INSERT ON public.siparis_urun FOR EACH ROW EXECUTE FUNCTION public.urun_tutar_hesapla();
 D   DROP TRIGGER trg_before_insert_siparis_urun ON public.siparis_urun;
       public          postgres    false    240    270            3           2620    49931    urun trg_before_insert_urun    TRIGGER     |   CREATE TRIGGER trg_before_insert_urun BEFORE INSERT ON public.urun FOR EACH ROW EXECUTE FUNCTION public.urun_adi_duzenle();
 4   DROP TRIGGER trg_before_insert_urun ON public.urun;
       public          postgres    false    257    226            9           2620    49877    boylar trg_before_update_boylar    TRIGGER        CREATE TRIGGER trg_before_update_boylar BEFORE UPDATE ON public.boylar FOR EACH ROW EXECUTE FUNCTION public.boy_adi_duzenle();
 8   DROP TRIGGER trg_before_update_boylar ON public.boylar;
       public          postgres    false    253    236            7           2620    49819    ilceler trg_before_update_ilce    TRIGGER        CREATE TRIGGER trg_before_update_ilce BEFORE UPDATE ON public.ilceler FOR EACH ROW EXECUTE FUNCTION public.ilce_adi_duzenle();
 7   DROP TRIGGER trg_before_update_ilce ON public.ilceler;
       public          postgres    false    232    252            *           2620    49881 #   kategori trg_before_update_kategori    TRIGGER     �   CREATE TRIGGER trg_before_update_kategori BEFORE UPDATE ON public.kategori FOR EACH ROW EXECUTE FUNCTION public.kategori_adi_duzenle();
 <   DROP TRIGGER trg_before_update_kategori ON public.kategori;
       public          postgres    false    202    254            +           2620    49883    menu trg_before_update_menu    TRIGGER     |   CREATE TRIGGER trg_before_update_menu BEFORE UPDATE ON public.menu FOR EACH ROW EXECUTE FUNCTION public.menu_adi_duzenle();
 4   DROP TRIGGER trg_before_update_menu ON public.menu;
       public          postgres    false    255    204            .           2620    49875 #   personel trg_before_update_personel    TRIGGER     �   CREATE TRIGGER trg_before_update_personel BEFORE UPDATE ON public.personel FOR EACH ROW EXECUTE FUNCTION public.personel_ad_soyad_duzenle();
 <   DROP TRIGGER trg_before_update_personel ON public.personel;
       public          postgres    false    212    247            4           2620    49817     sehirler trg_before_update_sehir    TRIGGER     �   CREATE TRIGGER trg_before_update_sehir BEFORE UPDATE ON public.sehirler FOR EACH ROW EXECUTE FUNCTION public.sehir_adi_duzenle();
 9   DROP TRIGGER trg_before_update_sehir ON public.sehirler;
       public          postgres    false    251    231            :           2620    49897 1   siparis_turleri trg_before_update_siparis_turleri    TRIGGER     �   CREATE TRIGGER trg_before_update_siparis_turleri BEFORE UPDATE ON public.siparis_turleri FOR EACH ROW EXECUTE FUNCTION public.siparis_turu_adi_duzenle();
 J   DROP TRIGGER trg_before_update_siparis_turleri ON public.siparis_turleri;
       public          postgres    false    256    238            2           2620    49930    urun trg_before_update_urun    TRIGGER     |   CREATE TRIGGER trg_before_update_urun BEFORE UPDATE ON public.urun FOR EACH ROW EXECUTE FUNCTION public.urun_adi_duzenle();
 4   DROP TRIGGER trg_before_update_urun ON public.urun;
       public          postgres    false    226    257                       2606    49802    adres adres_ilce_fkey    FK CONSTRAINT     x   ALTER TABLE ONLY public.adres
    ADD CONSTRAINT adres_ilce_fkey FOREIGN KEY (ilce) REFERENCES public.ilceler(ilce_id);
 ?   ALTER TABLE ONLY public.adres DROP CONSTRAINT adres_ilce_fkey;
       public          postgres    false    200    3077    232                       2606    49797    adres adres_sehir_fkey    FK CONSTRAINT     y   ALTER TABLE ONLY public.adres
    ADD CONSTRAINT adres_sehir_fkey FOREIGN KEY (sehir) REFERENCES public.sehirler(plaka);
 @   ALTER TABLE ONLY public.adres DROP CONSTRAINT adres_sehir_fkey;
       public          postgres    false    231    3075    200            %           2606    49789    ilceler ilceler_sehir_fkey    FK CONSTRAINT     }   ALTER TABLE ONLY public.ilceler
    ADD CONSTRAINT ilceler_sehir_fkey FOREIGN KEY (sehir) REFERENCES public.sehirler(plaka);
 D   ALTER TABLE ONLY public.ilceler DROP CONSTRAINT ilceler_sehir_fkey;
       public          postgres    false    3075    231    232                       2606    49636    menu_urun menu_urun_menu_fkey    FK CONSTRAINT     }   ALTER TABLE ONLY public.menu_urun
    ADD CONSTRAINT menu_urun_menu_fkey FOREIGN KEY (menu) REFERENCES public.menu(menu_id);
 G   ALTER TABLE ONLY public.menu_urun DROP CONSTRAINT menu_urun_menu_fkey;
       public          postgres    false    208    204    3041                       2606    49641    menu_urun menu_urun_urun_fkey    FK CONSTRAINT     }   ALTER TABLE ONLY public.menu_urun
    ADD CONSTRAINT menu_urun_urun_fkey FOREIGN KEY (urun) REFERENCES public.urun(urun_id);
 G   ALTER TABLE ONLY public.menu_urun DROP CONSTRAINT menu_urun_urun_fkey;
       public          postgres    false    208    226    3071                       2606    49626 *   menu_kategori menü_kategori_kategori_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.menu_kategori
    ADD CONSTRAINT "menü_kategori_kategori_fkey" FOREIGN KEY (kategori) REFERENCES public.kategori(kategori_id);
 V   ALTER TABLE ONLY public.menu_kategori DROP CONSTRAINT "menü_kategori_kategori_fkey";
       public          postgres    false    202    205    3039                       2606    49631 &   menu_kategori menü_kategori_menu_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.menu_kategori
    ADD CONSTRAINT "menü_kategori_menu_fkey" FOREIGN KEY (menu) REFERENCES public.menu(menu_id);
 R   ALTER TABLE ONLY public.menu_kategori DROP CONSTRAINT "menü_kategori_menu_fkey";
       public          postgres    false    3041    204    205                       2606    50296    musteri musteri_adres_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.musteri
    ADD CONSTRAINT musteri_adres_fkey FOREIGN KEY (adres) REFERENCES public.adres(adres_id) NOT VALID;
 D   ALTER TABLE ONLY public.musteri DROP CONSTRAINT musteri_adres_fkey;
       public          postgres    false    210    3037    200                       2606    49651    personel personel_adres_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.personel
    ADD CONSTRAINT personel_adres_fkey FOREIGN KEY (adres) REFERENCES public.adres(adres_id) ON DELETE CASCADE;
 F   ALTER TABLE ONLY public.personel DROP CONSTRAINT personel_adres_fkey;
       public          postgres    false    3037    212    200                       2606    49656    personel personel_sube_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.personel
    ADD CONSTRAINT personel_sube_fkey FOREIGN KEY (sube) REFERENCES public.sube(sube_id) ON DELETE CASCADE;
 E   ALTER TABLE ONLY public.personel DROP CONSTRAINT personel_sube_fkey;
       public          postgres    false    3063    212    220                       2606    49661    personel personel_unvan_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.personel
    ADD CONSTRAINT personel_unvan_fkey FOREIGN KEY (unvan) REFERENCES public.unvan(unvan_id) ON DELETE CASCADE;
 F   ALTER TABLE ONLY public.personel DROP CONSTRAINT personel_unvan_fkey;
       public          postgres    false    3067    222    212            !           2606    49866 "   siparis_menu siparis_menu_boy_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.siparis_menu
    ADD CONSTRAINT siparis_menu_boy_fkey FOREIGN KEY (boy) REFERENCES public.boylar(boy_id);
 L   ALTER TABLE ONLY public.siparis_menu DROP CONSTRAINT siparis_menu_boy_fkey;
       public          postgres    false    236    215    3081                       2606    49671 #   siparis_menu siparis_menu_menu_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.siparis_menu
    ADD CONSTRAINT siparis_menu_menu_fkey FOREIGN KEY (menu) REFERENCES public.menu(menu_id);
 M   ALTER TABLE ONLY public.siparis_menu DROP CONSTRAINT siparis_menu_menu_fkey;
       public          postgres    false    3041    215    204                        2606    49676 &   siparis_menu siparis_menu_siparis_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.siparis_menu
    ADD CONSTRAINT siparis_menu_siparis_fkey FOREIGN KEY (siparis) REFERENCES public.siparis(siparis_id);
 P   ALTER TABLE ONLY public.siparis_menu DROP CONSTRAINT siparis_menu_siparis_fkey;
       public          postgres    false    215    3053    214                       2606    49681    siparis siparis_musteri_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.siparis
    ADD CONSTRAINT siparis_musteri_fkey FOREIGN KEY (musteri) REFERENCES public.musteri(musteri_id);
 F   ALTER TABLE ONLY public.siparis DROP CONSTRAINT siparis_musteri_fkey;
       public          postgres    false    3049    214    210                       2606    49686    siparis siparis_personel_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.siparis
    ADD CONSTRAINT siparis_personel_fkey FOREIGN KEY (personel) REFERENCES public.personel(personel_id);
 G   ALTER TABLE ONLY public.siparis DROP CONSTRAINT siparis_personel_fkey;
       public          postgres    false    214    3051    212                       2606    49691 "   siparis siparis_siparis_durum_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.siparis
    ADD CONSTRAINT siparis_siparis_durum_fkey FOREIGN KEY (siparis_durum) REFERENCES public.siparis_durum(siparis_durum_id);
 L   ALTER TABLE ONLY public.siparis DROP CONSTRAINT siparis_siparis_durum_fkey;
       public          postgres    false    3059    214    218                       2606    49904 $   siparis siparis_siparis_turleri_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.siparis
    ADD CONSTRAINT siparis_siparis_turleri_fkey FOREIGN KEY (siparis_turu) REFERENCES public.siparis_turleri(tur_id);
 N   ALTER TABLE ONLY public.siparis DROP CONSTRAINT siparis_siparis_turleri_fkey;
       public          postgres    false    214    3083    238                       2606    49853    siparis siparis_sube_fkey    FK CONSTRAINT     y   ALTER TABLE ONLY public.siparis
    ADD CONSTRAINT siparis_sube_fkey FOREIGN KEY (sube) REFERENCES public.sube(sube_id);
 C   ALTER TABLE ONLY public.siparis DROP CONSTRAINT siparis_sube_fkey;
       public          postgres    false    3063    214    220            (           2606    49940 "   siparis_urun siparis_urun_boy_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.siparis_urun
    ADD CONSTRAINT siparis_urun_boy_fkey FOREIGN KEY (boy) REFERENCES public.boylar(boy_id);
 L   ALTER TABLE ONLY public.siparis_urun DROP CONSTRAINT siparis_urun_boy_fkey;
       public          postgres    false    3081    240    236            &           2606    49917 &   siparis_urun siparis_urun_siparis_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.siparis_urun
    ADD CONSTRAINT siparis_urun_siparis_fkey FOREIGN KEY (siparis) REFERENCES public.siparis(siparis_id);
 P   ALTER TABLE ONLY public.siparis_urun DROP CONSTRAINT siparis_urun_siparis_fkey;
       public          postgres    false    240    3053    214            '           2606    49922 #   siparis_urun siparis_urun_urun_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.siparis_urun
    ADD CONSTRAINT siparis_urun_urun_fkey FOREIGN KEY (urun) REFERENCES public.urun(urun_id);
 M   ALTER TABLE ONLY public.siparis_urun DROP CONSTRAINT siparis_urun_urun_fkey;
       public          postgres    false    3071    240    226            "           2606    50291    sube sube_adres_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.sube
    ADD CONSTRAINT sube_adres_fkey FOREIGN KEY (adres) REFERENCES public.adres(adres_id) NOT VALID;
 >   ALTER TABLE ONLY public.sube DROP CONSTRAINT sube_adres_fkey;
       public          postgres    false    3037    200    220            #           2606    49721 )   urun_kategori urun_kategori_kategori_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.urun_kategori
    ADD CONSTRAINT urun_kategori_kategori_fkey FOREIGN KEY (kategori) REFERENCES public.kategori(kategori_id);
 S   ALTER TABLE ONLY public.urun_kategori DROP CONSTRAINT urun_kategori_kategori_fkey;
       public          postgres    false    227    3039    202            $           2606    49726 %   urun_kategori urun_kategori_urun_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.urun_kategori
    ADD CONSTRAINT urun_kategori_urun_fkey FOREIGN KEY (urun) REFERENCES public.urun(urun_id) ON DELETE CASCADE;
 O   ALTER TABLE ONLY public.urun_kategori DROP CONSTRAINT urun_kategori_urun_fkey;
       public          postgres    false    226    227    3071            �   .  x�}RAJ�@<W��Hz&���� ���ziM`�du�,��W}��0��"��@S�EU�8ƣl���v�Fޤ�Gyg����X�d���ك� ��^�sr�y�K#�$�#x$ɕ�� C��ʔ��I*8N�%؇�\��Y�g���� A%(�B �K�[6~j�K�og;��Uc�Ov��`��	�AM��L!]D̀��i7`��n�XwZ�xN#��jй���n�K��;ۤ���:�?c���iϤ̟ש_ۺǙb��'#�/8Xj����ӈH)R�X�ߞ>�V7��f=7�n3H����pMDߏh�k      �   1   x�3��/*I�2�<ܞ�\��e��txO��=�\��އ�^b��qqq G��      �      x�e[K��ر�W�8�?0��e�CVw��v�:������ �ro9���j�#��վ��U �~3fη��N����Csن!����<�����M��g�cx�r�ND%��}��w���-YE���I7&q����ͥ{�"&�~��pǤ�ǩ��ފȢ��_����˗QD���&��mIቡ߿|�&e�z���>��7c�\�l�i��APG�����-{"]EiƧf���<�ޭѝ�p��mOA�S��?�� F��������](�׏�����S0e�fߝ��WhA��g���n�e���F�8zۣ��+q��n�ݸ4"؜a�k;��5(�=�ɣS��=x��SD��oڢ�hn�C��ٮb��%��o����r�ՠ|�f��a���g��k&я��0_L�w��{�}l��<�^�xR��ST`��g�v����0��Sx�l�UbF�^��uaL������7,�����E[����=ɘ8z݇�%�/��%�������sӊI�����O��c����B�ח/��AX#;��A��~�@Ψ�~������+,��N��u����Y�0�]��k�rW�L8�"�ݦ)���	f��zj��mׇ�e�~l0Bl�;�����5Z�����CزѤ�U�S��a�]܅S�fU	VZ�����˃W�w���q���Uv�����]�����.�"z���)Ui;�_�v^�7F������W��^��&#��yu��VBT�4� p�aYր�cC���С	�Z#��p��(v����)`��x�Z����t�y1&��M}7=�	�;��6�0�p3r*��臦96�z���C�b Vva{3reN��p7�h�v�f7�WX��g��t��a�z�0a�T��q�� L�xZ�.����?�� ���+��p��װ���Q�DB�~�����e�[�^�K��+�+Bw���h���̱�\����a��k1���1� ���	��邉�������m$����{k�J`�����_\b�_[ؘ4z3m:1���"��O�����kg-�~�{���'k�� ��V���n��\�[.&/$(#�	����q�$]�����$�S�h �~	�a4�ɠu;����F F�r6�^SH��#>�̮PQ���@��w�����[��f����f*g�4'�	Τ����@ONd��q�x{ *�,��=�a�%&�M7l�t���7��4?��.����|g�ǩ9x� 'v���Ή�8���m������]-d
�f�'�MO�U^rd�$����ƍ,����MG���5�!=�y;e����#͐�����DB?��5H_�q3�a��i����6���	^ԛ˱,l�jd�)i��f�?�*�?Ӳ2�p��l��j���	��z�v3��O�UA��arL�u�\ͣ 2'L�9�\a�fĹ������M�}��72�j�F�ei;�Z��|�G�6��@�Z�"��Q�L&����̍�����K�t�_
j��6�p)���RF���oz�q�t݆�	M) q�b��l�6����k��4��M��~��)<�W������]����*CnLa�m�S���O�%G'1��_�]��t��5�6͠I'��	n���	�������+ _�t��	9r�9�G��Üf�|�ebc^��]�]Δ�jwˌ���i15�'n�PʍJ�/���������(:�����agniWB��6�tI0���X�ѝ#�Q�Nc*��	�B{���U���}l�O8X_��9�?%�jБZyB��K+��j`��ł9V͉��A:ɧ�rU^�����3����]��%v[�����~oo����17I���fM�r��δ�39��/��:���d%C�pQ�bL�~���h��x������@�~��;1��7ϻ�p���+�fo0cs� g�<�1F봥ClF!�C�8d\MP��0�ET�&�P��	H��Sl�c��%��-�����[��Eh�X�r���/��2��Tp	{́��W4-�1򎡰A:���')��R��gJ���ӽ���:���Swp�G�s��B:�S�e���o'�'�͕��-㰌}�M={;, �r���G�}�!P
�P0���kr�3���d���q���0Bb��:���<�1>�/���q�1��
Ռ?-n6l���.̷P��[�if����9G���c)������ˍ����Q�!D
j��x�W�@��lh\	Û�<�����C��*��r�	���#���H��1��;M�D:�M�-�E�ى
� e�a�?O~s̆���1&f�lq�	|�v�;����x�z�����y�^��5�2�F.0���]�k��uT1d�j��)�V�iǀ'���@��2�� {[]�#�o�/a�8�xG�P'ܘ,�{��w�x�l� ��\˵YaQ��g�	X�_�Z%�}���������d��˗m`P����X��y����@��1.���lu�"���Y%5��.�d"�Y���BU�2���޽R�z�ْ�C}���D?A�`��ψݮ6vb2H��L΀QHd3{�ӫw��h��6�;�M1X��hA#껤ם��@�����smc���kq������8�0bNп��$aA�9�}��a�^
Âq[r��a.�����И���j��0<��X$faS���b��+BW��k�31y�6L�3�"0x��3��ϱg4e���%V���3�NF�JR>�3JjD�ݜ�tE�Fm��c�����9R�)K�-^�<��0,�I��8���閐5�+��2�X�F����A����V�܈�gLD�H�(���3���7&ss���kfTX�����hy�ަ	i��I1��ړ�����c�PG�h�	�E����L��#����2�7!�I�9����bN8\"�0�z���d���/�67w������JЪ��_�b�PxV��4�=��%d|9D�0\H&$v3��vX��fFY����a��[ţLS|[��Z��03~/�sk.�Q���lc�('� Q|��vr���l�?�����VVĩ郅GF�0�#΃%�}fv�!����Mk��?��a&�eE\ρ��`��ח���c�u��J��ӏ�':7�0ݘT2t������/!R�n��j<�Ռ(��>�G�4װ�Wz��Y�[p�j(�q�LLN����譕�n�d��Z1���%c����B+�9Ƿp�p}��e�8��;���\N��by������ds�V3nT�,�f͈Dz�O�29;���<��L��y�ɭqp�4؉�Q��1[X�(����g�|Y��+Sn�oDL�b�G]b�/���K҇J�gџ�Y�ɕ�mh3���TQ
6w�a�sm���j 6�5� ~�/�s�i>��0�����ql;���2�4G�:ň����8fQ�u7����N˟���_�Ĵ��Ӄ��e����t�N\�W9Fq��tO)�R%��@^��dJ�Qɝ��+�����gQ��*ٔ!�܍e+ԼV)�W˝�=�)�Z%p�h�X8����YOA�A��kh�<t�/�7���,!�3H�ʌe_h��遹z�zPplx�)_��ܱ��
�+��}g3��p�6ҁh����T���Lr��Z�9����G��ԝ`�7�N^��$�<g����St�vg7Øfg��)��gS�;����`W-ʱ�u�b�@0�D�����h猕8�����@��+���0j6�ӔO�1�c��3��m�ry�k%���.����ҫ/.�+�
�w,�R<�ڹ��8�U�Ћ��D�ɒ`v��m\��Ϭ*�,�Qs�숀ۻ��Zt���A���`�΍��S�����AN�j˂I�C�4:�31&�T�A	}g�T���A�����nP�}8;̙�cօ=SD����@8BԻ �b���^����؁����2�a�W��ؼ�n!�l�S�eM:��f����������Ct0wC��.�,��6�� R
  ���"E��|������ �o�q��iY�b��G��~��/�~���.<���f)���C��i��+f�ETbLi�W�6��D#����7C_��P�$b�����J܀?�bRE����8� x�ը�o8�߲��h
6�a�-6��ً5�ɂ#1��
@��P����&
Sr�3�Ū^^QZQE溜��s��	#�c�J��*=L�T<�������u�bD�R�e�� �t�Ზ����Jt��T,�e5�nPV�x��J�zб��R�@�PF�)ᚧ�*�A��m������tt��q%��)F�>ÙݘsoV�~3N��!F5����p�N���\��A%kW�j?�
��4�����ݾe"�&B��f }
�0"C;:s��0�y���d���!��\h�j�J���dE�8�w� 9�?}�1Sq�/d8��i�Ss�/G'_�
�ft����N��)�-u��5��߉ L�߸JE�<�2�@�����׃aFr�	�̱!�^�<&͢���S��9�1�n�1J�L�ka\�K�E�۲:(Oas/kD];�u��p:C�%k4��9�O�U�	!��(Ş9zVԘ�Y�9� ]�~=�U(�������ay��(EF(!Kn���L��0����`�M�S��bȘ1���0?��:l��z[�\������?����)���g���c�w�B�C0��
䎋�hKwz6�1S��1(.q*��N�}Ք$C���5#r�ۦ�D��:��H�����y�����2�F1#wi�Q��\G��cMN$r�`ڨ�|ߔ��FF��Cse`������G�i��֡y�|�`m�{LD����6�w5������2�F$���Y�SX���y����Eg��"���c������GyN�£G��!%"����)�����D:B�ƥ5C�,�R�Ʀ<��GY�O��sZ�X����at�;��}��N�U���%��P���S��jyR��������YyD^ӂ]���c��N��X@e�aDγR8!�c�F���J���S1K������"�����+V:���/�+r/��=,O�T�QS ���P�����S����2u�~t,RU��8����^�Dd\#W}�-:)��F�hŨ8��n�fNv~`iLz_�cT����]��T�c��W&N����r2
Bf'���,������A����â;���35oG��q�yI���Wr��bGC��AU�A	;c�=�-a��
��S���6���S��2;�ƣ�#��k�n[�"��=q4"v۷�V�&��(��|KI�oU�,\E�	�)�Q5�-֖ �7���x�Q�XƸTI`j���љ
�U��Z�Q���RĤδw�aQ�̤A�jf��y��[��}P���8���&,P��	9����Xhw-3g�sy�q�/�.�~��n,3�a��2j6�;���|�84����3�����m=y�yFw��v#��O[	ye�z�W��+���y�#�#�l��QZEook@T5%���N�� pj;���NŬ`hFF�Do�}�8��>����4-D>�aa�(��#��y#EN��t����V�*�Z�;�:d-���1�n�
V�Vg��1���o19ӻ�m��[�+[��=Yv�*}1��xC�i�u��D��д�W�k8���I�l� �3i3����в�,P�w!�y5�.`�����J,��ӝ[y����Q�T����(W+?��^�����P_G<�ZB��0�g8Sv�!��m,!sVdF�7�KUC�[���<L=�]���P�a���Xw[Q��Ӹ9�i�R$>XPi_�F+ST�����XW��E1����%�OUXU�#~�t}a3v8� +���f��Ue���{#��hϰ��������_���gs5�%}�|??���1�Bg���O4űn2�b�a=�*����X҅5�S����~���M3̭,*�k��?�2TJ�o�Q�*��~T�*J���
%���g���{ .�}|eDb��fW��	k�^�tv6<�p�c�(���ªW4 "�A�}��t�eG)b�Yk�S��_��(;x6"��E"Re��3;QY�����Q�˗���>�ٳ����x���Z�+���Y��)��^��D�۠�eߴ�������}���r�����U�nd>WH3&ꛇ�����s6�d����������q3OBێ%I�4�ƻQ�ʽ>�Q�0O�^>�3��z՜�y8��d��}�'*���D��¿���H;�_Ϻ�f�=QnU�~
a)+�Y�_8��5��7(�#�1L+�H�g�g���=:*��`R͋���1��uQ�������t̮	�Ѝ�RW�1�_hDf�tc^�3�챹���͇8�s+RrT�k�#`�2���y{j~�z���Z7T�X��Q��:f
�Np���y�����<f�L�H�u�rVJzm�1��������$�M���)��G�r��T��?X$�XP�`�/����ψc�o�؜(y"R�ܨ�װ�f��"�E��/�<�o�2��!�+�p�:�R4�b77i���˕��	���%U���<��
$�a�����G[M����w�}�!���      �   v   x�3��H�M*-JO-�2�t�HM-N�r�9��R�3�3�L8}3s��3�S�,8CKr�l�I,��<���������C΀̪�D.CCN��⒢D�C#����l.C�1�`cb���� �c(�      �   �   x�e�Mn�@F��)|��	3��N�H�I��Hݘ�(�AS�EΖ+"�.��'�H�q\LOWǁ)��L�4����;���v�I�H��F���r����Ȇʿ�29�AA*�i㻼Z�"��^G��V��|���p	/�o۟l�c��B<�I����d�j���c���_�ҨbH�|�O�Q��r�08pq:�r�^��	�>i_      �   (   x�3�4�4�2�4�4�2���,8M��%��	W� L�<      �   4   x�˱  ��+�Dz��:|��և'd��"e����Cɢe���q'� ��l      �   �  x���Mj�0���a�>�>�n$�iSZ
���n�$Ә�5$)�^�����4s�yIk���`		�������z�Gh�Z�L������A����ݓ�.��/C/���-�C��#ܭ�"�,�"�t���p�#$�$,$��[�=wp^^�řŅ�MCw��?���,�-H+i5N���u�Ԍ�͢�Z�.ӡ���[M/�>����F���I嬨D�bn-g*!�M�FG�Ka�L�6�r	��k.>`��b�5|�~}\ê��[އ ���%��t�����c�#��r�{�9�[�4+��c*���,!s�ı�F��^�����W	�Y���bmu��R�[��k&�&$F��2Yl�#�9Dgrt���}_��~��=����u{�
      �   
  x���MjA��5��d���v����!�o�HHB��!X������+ՒG1D�43=C���y��y�Z�xz�� �7w�~�"y҈ʂB�#R�����i5��z������QAa �� yhW�w���m������~�1���'z΂�A=�?��,H���R��$�6����Q5t���%�z��&.��~w]���lQ3]�w��P�0�@�P�d�	��r��#咝�ɣ��)�l�K���J��:,���jm�$Pm�7�s�$��vb�X���Ã|��9�4�|=��v�߭d\�|�Z'Cp;�'�o����!�'^�������ƈ�:�R�.����[�˱�\T�rЁ9z�هĿ7Q��4Z�\K�on�|��ȃ�?Zk��ԕ�v��C?�kNֽ��j��EGL�(]�$���bg���.�2ʷ�P1�pdmRk�2S����męX&r�Zխ�A6�,��Q�� ��fu_��*�I���!b�����"�E~���E�4� F(|      �   `  x�-�Kn�0��3�)LQ//�H�	иRt3����L�d@�@oQ]��t��{���������h�'�;�;9�cM���r�b�x�G�;��/�A4R�(��oN��B8V3��r<�����;[��-XE�����d�!��֬b��ʖUBw�߷x�U����Q\QHiX�U��P��ê|{�hF��پ�)������[E��[�G�����y8�i�{�v�4J�n�0)-���s@�QF�[q���(��M��������r��zF_C}޲V��t�#z�?�7�Z�����1��Fܶ-Y'0�#��V�k��p+ײ�at�	A�B+E)ޠ�x6��EƊV�N&G鰎X��zi�tLk)�	2�tC����;�g8�{��nǡ�_2�'s�̔(z��7�D�-q���a��"�9������b�o8� \��Iq���9mLa�^��tF����SE/�ХmZ�M��n��ֿ����)8M�����Z���yF?+�ޖ���E�;N� �۶�$��AOxgj" ���@�4�#��q,���s�Q�!�H�cpe�JY��/�S����gؗX�3z��v�s`y��;ÿ�0�fF �      �   3   x�36�4202�54�5�P00�2��24�411�3���4�4BC�=... ��}      �   C   x�3��H�:���ˈ32?'%�˘�Ȇ���.�LNbޑ���E\��!��9��
�)�9)�\1z\\\ �B<      �      x�35�4�46FF�\1z\\\ ��      �   1   x�3�<:�4)5%5O!$�8'3�ˈ�?/'3/U!8� �(��|�=... 7�      �      x�31�46�4�4�445������ 3�      �   �   x�Eͽ�@��y��ͥ�L��(B�B)��a��p�ᣡ�?�=p�����	�"x=d��04���E�C���'�%+��^�y�мhT�67ݿ*�&�;��֓�r�$��X��Řt&��Ydko|�u4^��s0.      �   �   x�5ͯ�0�q}�}B��G�A,S 1+�A�%׎d��$zf������|2����O�����R��b��u���Wp��^������Q \�AWZ�%�Xn�h8�n!�t�1���N��+�!�cͮQYíE=�}���?%39�      �   �   x����0��M�	���W�$R�<A$�#��	X�!�O���Nw��/���KJь'I����2l�z�V�r�''62��->1qM%�ўn�1a��i��\�=JE56f�|�N����s>23���.�v��򁮙�+"�h�,�      �   .   x�3����2�P&�B�qZ�(sN#e�,!�������� ��     