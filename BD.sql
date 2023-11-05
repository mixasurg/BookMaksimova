PGDMP  #        
        
    {            Miniatures_store    15.4    16.0 3    @           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            A           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            B           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            C           1262    32935    Miniatures_store    DATABASE     �   CREATE DATABASE "Miniatures_store" WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'Russian_Russia.1251';
 "   DROP DATABASE "Miniatures_store";
                postgres    false            �            1259    32971    Users    TABLE     �   CREATE TABLE public."Users" (
    user_id integer NOT NULL,
    name text NOT NULL,
    contact text,
    username text NOT NULL,
    password text NOT NULL,
    is_active boolean,
    is_artist boolean DEFAULT false NOT NULL
);
    DROP TABLE public."Users";
       public         heap    postgres    false            �            1259    49334    Clients_customer_id_seq    SEQUENCE     �   ALTER TABLE public."Users" ALTER COLUMN user_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public."Clients_customer_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            public          postgres    false    218            �            1259    32950    Kategory    TABLE     X   CREATE TABLE public."Kategory" (
    kategory_id integer NOT NULL,
    kategory text
);
    DROP TABLE public."Kategory";
       public         heap    postgres    false            �            1259    49328    Kategory_kategory_id_seq    SEQUENCE     �   ALTER TABLE public."Kategory" ALTER COLUMN kategory_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public."Kategory_kategory_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            public          postgres    false    215            �            1259    32957    Material    TABLE     X   CREATE TABLE public."Material" (
    material_id integer NOT NULL,
    material text
);
    DROP TABLE public."Material";
       public         heap    postgres    false            �            1259    49329    Material_material_id_seq    SEQUENCE     �   ALTER TABLE public."Material" ALTER COLUMN material_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public."Material_material_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            public          postgres    false    216            �            1259    33087 
   Miniatures    TABLE     �   CREATE TABLE public."Miniatures" (
    "miniature_ID" integer NOT NULL,
    name text,
    kategory_id integer,
    material_id integer,
    photos_id integer,
    artist_id integer
);
     DROP TABLE public."Miniatures";
       public         heap    postgres    false            �            1259    49333    Miniatures_miniature_ID_seq    SEQUENCE     �   ALTER TABLE public."Miniatures" ALTER COLUMN "miniature_ID" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public."Miniatures_miniature_ID_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            public          postgres    false    220            �            1259    32978    Orders    TABLE     �   CREATE TABLE public."Orders" (
    "order_ID" integer NOT NULL,
    "customer_ID" integer,
    status_id integer,
    order_date date,
    completion_date date,
    description text
);
    DROP TABLE public."Orders";
       public         heap    postgres    false            �            1259    33109 
   Orders_row    TABLE       CREATE TABLE public."Orders_row" (
    "order_ID" integer NOT NULL,
    string_id integer NOT NULL,
    "artist_ID" integer,
    status_id integer,
    order_date date,
    completion_date date,
    description text,
    amount numeric,
    product_id integer
);
     DROP TABLE public."Orders_row";
       public         heap    postgres    false            �            1259    49332    Orders_row_string_id_seq    SEQUENCE     �   ALTER TABLE public."Orders_row" ALTER COLUMN string_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public."Orders_row_string_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            public          postgres    false    221            �            1259    32936    Photos    TABLE     y   CREATE TABLE public."Photos" (
    "photos_ID" integer NOT NULL,
    string_photo_id integer NOT NULL,
    "URL" text
);
    DROP TABLE public."Photos";
       public         heap    postgres    false            �            1259    49331    Photos_string_photo_id_seq    SEQUENCE     �   ALTER TABLE public."Photos" ALTER COLUMN string_photo_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public."Photos_string_photo_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            public          postgres    false    214            �            1259    32964    Status    TABLE     R   CREATE TABLE public."Status" (
    status_id integer NOT NULL,
    status text
);
    DROP TABLE public."Status";
       public         heap    postgres    false            �            1259    49330    Status_status_id_seq    SEQUENCE     �   ALTER TABLE public."Status" ALTER COLUMN status_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public."Status_status_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            public          postgres    false    217            0          0    32950    Kategory 
   TABLE DATA           ;   COPY public."Kategory" (kategory_id, kategory) FROM stdin;
    public          postgres    false    215   �;       1          0    32957    Material 
   TABLE DATA           ;   COPY public."Material" (material_id, material) FROM stdin;
    public          postgres    false    216   A<       5          0    33087 
   Miniatures 
   TABLE DATA           l   COPY public."Miniatures" ("miniature_ID", name, kategory_id, material_id, photos_id, artist_id) FROM stdin;
    public          postgres    false    220   �<       4          0    32978    Orders 
   TABLE DATA           r   COPY public."Orders" ("order_ID", "customer_ID", status_id, order_date, completion_date, description) FROM stdin;
    public          postgres    false    219   �<       6          0    33109 
   Orders_row 
   TABLE DATA           �   COPY public."Orders_row" ("order_ID", string_id, "artist_ID", status_id, order_date, completion_date, description, amount, product_id) FROM stdin;
    public          postgres    false    221   �<       /          0    32936    Photos 
   TABLE DATA           G   COPY public."Photos" ("photos_ID", string_photo_id, "URL") FROM stdin;
    public          postgres    false    214   =       2          0    32964    Status 
   TABLE DATA           5   COPY public."Status" (status_id, status) FROM stdin;
    public          postgres    false    217   �=       3          0    32971    Users 
   TABLE DATA           c   COPY public."Users" (user_id, name, contact, username, password, is_active, is_artist) FROM stdin;
    public          postgres    false    218   )>       D           0    0    Clients_customer_id_seq    SEQUENCE SET     G   SELECT pg_catalog.setval('public."Clients_customer_id_seq"', 3, true);
          public          postgres    false    228            E           0    0    Kategory_kategory_id_seq    SEQUENCE SET     H   SELECT pg_catalog.setval('public."Kategory_kategory_id_seq"', 3, true);
          public          postgres    false    222            F           0    0    Material_material_id_seq    SEQUENCE SET     H   SELECT pg_catalog.setval('public."Material_material_id_seq"', 3, true);
          public          postgres    false    223            G           0    0    Miniatures_miniature_ID_seq    SEQUENCE SET     L   SELECT pg_catalog.setval('public."Miniatures_miniature_ID_seq"', 14, true);
          public          postgres    false    227            H           0    0    Orders_row_string_id_seq    SEQUENCE SET     I   SELECT pg_catalog.setval('public."Orders_row_string_id_seq"', 1, false);
          public          postgres    false    226            I           0    0    Photos_string_photo_id_seq    SEQUENCE SET     K   SELECT pg_catalog.setval('public."Photos_string_photo_id_seq"', 41, true);
          public          postgres    false    225            J           0    0    Status_status_id_seq    SEQUENCE SET     D   SELECT pg_catalog.setval('public."Status_status_id_seq"', 7, true);
          public          postgres    false    224            �           2606    32977    Users Clients_pkey 
   CONSTRAINT     Y   ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Clients_pkey" PRIMARY KEY (user_id);
 @   ALTER TABLE ONLY public."Users" DROP CONSTRAINT "Clients_pkey";
       public            postgres    false    218            �           2606    32956    Kategory Kategory_pkey 
   CONSTRAINT     a   ALTER TABLE ONLY public."Kategory"
    ADD CONSTRAINT "Kategory_pkey" PRIMARY KEY (kategory_id);
 D   ALTER TABLE ONLY public."Kategory" DROP CONSTRAINT "Kategory_pkey";
       public            postgres    false    215            �           2606    32963    Material Material_pkey 
   CONSTRAINT     a   ALTER TABLE ONLY public."Material"
    ADD CONSTRAINT "Material_pkey" PRIMARY KEY (material_id);
 D   ALTER TABLE ONLY public."Material" DROP CONSTRAINT "Material_pkey";
       public            postgres    false    216            �           2606    33093    Miniatures Miniatures_pkey 
   CONSTRAINT     h   ALTER TABLE ONLY public."Miniatures"
    ADD CONSTRAINT "Miniatures_pkey" PRIMARY KEY ("miniature_ID");
 H   ALTER TABLE ONLY public."Miniatures" DROP CONSTRAINT "Miniatures_pkey";
       public            postgres    false    220            �           2606    32984    Orders Orders_pkey 
   CONSTRAINT     \   ALTER TABLE ONLY public."Orders"
    ADD CONSTRAINT "Orders_pkey" PRIMARY KEY ("order_ID");
 @   ALTER TABLE ONLY public."Orders" DROP CONSTRAINT "Orders_pkey";
       public            postgres    false    219            �           2606    33115    Orders_row Orders_row_pkey 
   CONSTRAINT     o   ALTER TABLE ONLY public."Orders_row"
    ADD CONSTRAINT "Orders_row_pkey" PRIMARY KEY ("order_ID", string_id);
 H   ALTER TABLE ONLY public."Orders_row" DROP CONSTRAINT "Orders_row_pkey";
       public            postgres    false    221    221            �           2606    32942    Photos Photos_pkey 
   CONSTRAINT     n   ALTER TABLE ONLY public."Photos"
    ADD CONSTRAINT "Photos_pkey" PRIMARY KEY ("photos_ID", string_photo_id);
 @   ALTER TABLE ONLY public."Photos" DROP CONSTRAINT "Photos_pkey";
       public            postgres    false    214    214            �           2606    32970    Status Status_pkey 
   CONSTRAINT     [   ALTER TABLE ONLY public."Status"
    ADD CONSTRAINT "Status_pkey" PRIMARY KEY (status_id);
 @   ALTER TABLE ONLY public."Status" DROP CONSTRAINT "Status_pkey";
       public            postgres    false    217            �           2606    65703    Orders_row 1    FK CONSTRAINT     �   ALTER TABLE ONLY public."Orders_row"
    ADD CONSTRAINT "1" FOREIGN KEY (product_id) REFERENCES public."Miniatures"("miniature_ID") NOT VALID;
 :   ALTER TABLE ONLY public."Orders_row" DROP CONSTRAINT "1";
       public          postgres    false    221    3221    220            �           2606    57517    Orders_row Artist    FK CONSTRAINT     �   ALTER TABLE ONLY public."Orders_row"
    ADD CONSTRAINT "Artist" FOREIGN KEY ("artist_ID") REFERENCES public."Users"(user_id) NOT VALID;
 ?   ALTER TABLE ONLY public."Orders_row" DROP CONSTRAINT "Artist";
       public          postgres    false    3217    218    221            �           2606    32985    Orders Client    FK CONSTRAINT     }   ALTER TABLE ONLY public."Orders"
    ADD CONSTRAINT "Client" FOREIGN KEY ("customer_ID") REFERENCES public."Users"(user_id);
 ;   ALTER TABLE ONLY public."Orders" DROP CONSTRAINT "Client";
       public          postgres    false    3217    218    219            �           2606    33116    Orders_row Order    FK CONSTRAINT     �   ALTER TABLE ONLY public."Orders_row"
    ADD CONSTRAINT "Order" FOREIGN KEY ("order_ID") REFERENCES public."Orders"("order_ID");
 >   ALTER TABLE ONLY public."Orders_row" DROP CONSTRAINT "Order";
       public          postgres    false    3219    219    221            �           2606    32990    Orders Status    FK CONSTRAINT     |   ALTER TABLE ONLY public."Orders"
    ADD CONSTRAINT "Status" FOREIGN KEY (status_id) REFERENCES public."Status"(status_id);
 ;   ALTER TABLE ONLY public."Orders" DROP CONSTRAINT "Status";
       public          postgres    false    219    3215    217            �           2606    33126    Orders_row Status    FK CONSTRAINT     �   ALTER TABLE ONLY public."Orders_row"
    ADD CONSTRAINT "Status" FOREIGN KEY (status_id) REFERENCES public."Status"(status_id);
 ?   ALTER TABLE ONLY public."Orders_row" DROP CONSTRAINT "Status";
       public          postgres    false    217    3215    221            �           2606    57512    Miniatures artist    FK CONSTRAINT     �   ALTER TABLE ONLY public."Miniatures"
    ADD CONSTRAINT artist FOREIGN KEY (artist_id) REFERENCES public."Users"(user_id) NOT VALID;
 =   ALTER TABLE ONLY public."Miniatures" DROP CONSTRAINT artist;
       public          postgres    false    218    3217    220            �           2606    33094    Miniatures kategor    FK CONSTRAINT     �   ALTER TABLE ONLY public."Miniatures"
    ADD CONSTRAINT kategor FOREIGN KEY (kategory_id) REFERENCES public."Kategory"(kategory_id);
 >   ALTER TABLE ONLY public."Miniatures" DROP CONSTRAINT kategor;
       public          postgres    false    220    215    3211            �           2606    33099    Miniatures material    FK CONSTRAINT     �   ALTER TABLE ONLY public."Miniatures"
    ADD CONSTRAINT material FOREIGN KEY (material_id) REFERENCES public."Material"(material_id);
 ?   ALTER TABLE ONLY public."Miniatures" DROP CONSTRAINT material;
       public          postgres    false    220    3213    216            0   :   x�3�O,�H��M-R01��2B��S���3�s���9=��2�2K*�b���� )��      1   >   x�3�0���.6^l����..#��/��t���V.cN�[�*�^l�
r��qqq \=$      5   .   x�3���+I-�N�N-�4C#.CcN�Ĳ���N#� P(F��� 
�
      4      x������ � �      6      x������ � �      /   �   x�}�M�  ����k���Z�A�)R4s��4���`�-|�@�br�ug��HD�(�jg��A_���@/��0�2�/�B�TcN�k�+�F�� �ڪ�Y������"������.�]���7���*J�EO       2   }   x�]���@F��7?�e�P�jf�DB	1+<o��h��=~^.������,���O�g����L$k�,����*�@W�!2F?U;zN���_�t�����d�z��.`���OlU      3   Q   x�3��ͬH,�0�b�Ŧ�=�>�y���`��4.#�s.��zaÅvs^�wa�
�BU���#%�%\1z\\\ vh(P     