PGDMP  /    4            
    {            Book_store_maksimova    15.4    16.0 1    a           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            b           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            c           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            d           1262    90293    Book_store_maksimova    DATABASE     �   CREATE DATABASE "Book_store_maksimova" WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'Russian_Russia.1251';
 &   DROP DATABASE "Book_store_maksimova";
                postgres    false            �            1259    90294    clients    TABLE     
  CREATE TABLE public.clients (
    client_id integer NOT NULL,
    client_name text NOT NULL,
    client_email text,
    username text,
    password text,
    is_active boolean DEFAULT false NOT NULL,
    CONSTRAINT clients_client_id_check CHECK ((client_id > 0))
);
    DROP TABLE public.clients;
       public         heap    postgres    false            �            1259    90419    clients_client_id_seq    SEQUENCE     �   ALTER TABLE public.clients ALTER COLUMN client_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.clients_client_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            public          postgres    false    214            �            1259    90319    order_statuses    TABLE     �   CREATE TABLE public.order_statuses (
    order_status_code smallint NOT NULL,
    order_status text NOT NULL,
    CONSTRAINT order_statuses_order_status_code_check CHECK ((order_status_code > 0))
);
 "   DROP TABLE public.order_statuses;
       public         heap    postgres    false            �            1259    90388    order_strings    TABLE     <  CREATE TABLE public.order_strings (
    order_id integer NOT NULL,
    row_number integer NOT NULL,
    product_id integer,
    product_amount integer,
    CONSTRAINT order_strings_order_id_check CHECK (((order_id > 0) AND (order_id IS NOT NULL))),
    CONSTRAINT order_strings_product_amount_check CHECK (((product_amount > 0) AND (product_amount IS NOT NULL))),
    CONSTRAINT order_strings_product_id_check CHECK (((product_id > 0) AND (product_id IS NOT NULL))),
    CONSTRAINT order_strings_row_number_check CHECK (((row_number > 0) AND (row_number IS NOT NULL)))
);
 !   DROP TABLE public.order_strings;
       public         heap    postgres    false            �            1259    90363    orders    TABLE     �  CREATE TABLE public.orders (
    worker_id integer,
    client_id integer,
    order_status_code smallint,
    creation_data timestamp without time zone NOT NULL,
    performance_data timestamp without time zone,
    order_id integer NOT NULL,
    CONSTRAINT orders_check CHECK (((performance_data > creation_data) AND (performance_data IS NOT NULL))),
    CONSTRAINT orders_client_id_check CHECK ((client_id > 0)),
    CONSTRAINT orders_order_id_check CHECK (((order_id > 0) AND (order_id IS NOT NULL))),
    CONSTRAINT orders_order_status_code_check CHECK ((order_status_code > 0)),
    CONSTRAINT orders_worker_id_check CHECK ((worker_id > 0))
);
    DROP TABLE public.orders;
       public         heap    postgres    false            �            1259    90447    orders_order_id_seq    SEQUENCE     �   ALTER TABLE public.orders ALTER COLUMN order_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.orders_order_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            public          postgres    false    221            �            1259    90311 	   producers    TABLE     �   CREATE TABLE public.producers (
    producer_id integer NOT NULL,
    producer_name text NOT NULL,
    CONSTRAINT producers_producer_id_check CHECK ((producer_id > 0))
);
    DROP TABLE public.producers;
       public         heap    postgres    false            �            1259    90327    product_categories    TABLE     �   CREATE TABLE public.product_categories (
    product_category_code integer NOT NULL,
    product_category text NOT NULL,
    CONSTRAINT product_categories_product_category_code_check CHECK ((product_category_code > 0))
);
 &   DROP TABLE public.product_categories;
       public         heap    postgres    false            �            1259    90348    products    TABLE       CREATE TABLE public.products (
    product_id integer NOT NULL,
    product_name text NOT NULL,
    price_purchase integer,
    price_sale integer,
    product_category_code integer NOT NULL,
    cover text DEFAULT '/static/cover/empty.png'::text,
    CONSTRAINT products_check CHECK (((price_sale > price_purchase) AND (price_sale IS NOT NULL))),
    CONSTRAINT products_price_purchase_check CHECK (((price_purchase > 0) AND (price_purchase IS NOT NULL))),
    CONSTRAINT products_product_id_check CHECK ((product_id > 0))
);
    DROP TABLE public.products;
       public         heap    postgres    false            �            1259    90421    products_product_id_seq    SEQUENCE     �   ALTER TABLE public.products ALTER COLUMN product_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.products_product_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            public          postgres    false    220            �            1259    90402    purchase_strings    TABLE     W  CREATE TABLE public.purchase_strings (
    purchase_id integer NOT NULL,
    row_number integer NOT NULL,
    product_id integer,
    product_amount integer,
    CONSTRAINT purchase_strings_product_amount_check CHECK (((product_amount > 0) AND (product_amount IS NOT NULL))),
    CONSTRAINT purchase_strings_product_id_check CHECK (((product_id > 0) AND (product_id IS NOT NULL))),
    CONSTRAINT purchase_strings_purchase_id_check CHECK (((purchase_id > 0) AND (purchase_id IS NOT NULL))),
    CONSTRAINT purchase_strings_row_number_check CHECK (((row_number > 0) AND (row_number IS NOT NULL)))
);
 $   DROP TABLE public.purchase_strings;
       public         heap    postgres    false            �            1259    90335 	   purchases    TABLE     �  CREATE TABLE public.purchases (
    purchase_id integer NOT NULL,
    producer_id integer,
    creation_data timestamp without time zone NOT NULL,
    performance_data timestamp without time zone,
    CONSTRAINT purchases_check CHECK ((performance_data > creation_data)),
    CONSTRAINT purchases_producer_id_check CHECK (((producer_id > 0) AND (producer_id IS NOT NULL))),
    CONSTRAINT purchases_purchase_id_check CHECK ((purchase_id > 0))
);
    DROP TABLE public.purchases;
       public         heap    postgres    false            �            1259    90302    workers    TABLE     �  CREATE TABLE public.workers (
    worker_id integer NOT NULL,
    worker_name text NOT NULL,
    worker_special_number bigint,
    worker_email text,
    username text,
    password text,
    is_active boolean DEFAULT false NOT NULL,
    CONSTRAINT workers_worker_id_check CHECK ((worker_id > 0)),
    CONSTRAINT workers_worker_special_number_check CHECK (((worker_special_number > 0) AND (worker_special_number IS NOT NULL)))
);
    DROP TABLE public.workers;
       public         heap    postgres    false            �            1259    90420    workers_worker_id_seq    SEQUENCE     �   ALTER TABLE public.workers ALTER COLUMN worker_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.workers_worker_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            public          postgres    false    215            Q          0    90294    clients 
   TABLE DATA           f   COPY public.clients (client_id, client_name, client_email, username, password, is_active) FROM stdin;
    public          postgres    false    214   �D       T          0    90319    order_statuses 
   TABLE DATA           I   COPY public.order_statuses (order_status_code, order_status) FROM stdin;
    public          postgres    false    217   E       Y          0    90388    order_strings 
   TABLE DATA           Y   COPY public.order_strings (order_id, row_number, product_id, product_amount) FROM stdin;
    public          postgres    false    222   �E       X          0    90363    orders 
   TABLE DATA           t   COPY public.orders (worker_id, client_id, order_status_code, creation_data, performance_data, order_id) FROM stdin;
    public          postgres    false    221   �E       S          0    90311 	   producers 
   TABLE DATA           ?   COPY public.producers (producer_id, producer_name) FROM stdin;
    public          postgres    false    216   �E       U          0    90327    product_categories 
   TABLE DATA           U   COPY public.product_categories (product_category_code, product_category) FROM stdin;
    public          postgres    false    218   �E       W          0    90348    products 
   TABLE DATA           v   COPY public.products (product_id, product_name, price_purchase, price_sale, product_category_code, cover) FROM stdin;
    public          postgres    false    220   4F       Z          0    90402    purchase_strings 
   TABLE DATA           _   COPY public.purchase_strings (purchase_id, row_number, product_id, product_amount) FROM stdin;
    public          postgres    false    223   H       V          0    90335 	   purchases 
   TABLE DATA           ^   COPY public.purchases (purchase_id, producer_id, creation_data, performance_data) FROM stdin;
    public          postgres    false    219   4H       R          0    90302    workers 
   TABLE DATA           }   COPY public.workers (worker_id, worker_name, worker_special_number, worker_email, username, password, is_active) FROM stdin;
    public          postgres    false    215   QH       e           0    0    clients_client_id_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('public.clients_client_id_seq', 1, true);
          public          postgres    false    224            f           0    0    orders_order_id_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('public.orders_order_id_seq', 1, false);
          public          postgres    false    227            g           0    0    products_product_id_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public.products_product_id_seq', 8, true);
          public          postgres    false    226            h           0    0    workers_worker_id_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('public.workers_worker_id_seq', 1, true);
          public          postgres    false    225            �           2606    90301    clients clients_pkey 
   CONSTRAINT     Y   ALTER TABLE ONLY public.clients
    ADD CONSTRAINT clients_pkey PRIMARY KEY (client_id);
 >   ALTER TABLE ONLY public.clients DROP CONSTRAINT clients_pkey;
       public            postgres    false    214            �           2606    90326 "   order_statuses order_statuses_pkey 
   CONSTRAINT     o   ALTER TABLE ONLY public.order_statuses
    ADD CONSTRAINT order_statuses_pkey PRIMARY KEY (order_status_code);
 L   ALTER TABLE ONLY public.order_statuses DROP CONSTRAINT order_statuses_pkey;
       public            postgres    false    217            �           2606    90372    orders orders_pkey 
   CONSTRAINT     V   ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_pkey PRIMARY KEY (order_id);
 <   ALTER TABLE ONLY public.orders DROP CONSTRAINT orders_pkey;
       public            postgres    false    221            �           2606    90410    purchase_strings pk 
   CONSTRAINT     f   ALTER TABLE ONLY public.purchase_strings
    ADD CONSTRAINT pk PRIMARY KEY (purchase_id, row_number);
 =   ALTER TABLE ONLY public.purchase_strings DROP CONSTRAINT pk;
       public            postgres    false    223    223            �           2606    90396    order_strings pk_new 
   CONSTRAINT     d   ALTER TABLE ONLY public.order_strings
    ADD CONSTRAINT pk_new PRIMARY KEY (order_id, row_number);
 >   ALTER TABLE ONLY public.order_strings DROP CONSTRAINT pk_new;
       public            postgres    false    222    222            �           2606    90318    producers producers_pkey 
   CONSTRAINT     _   ALTER TABLE ONLY public.producers
    ADD CONSTRAINT producers_pkey PRIMARY KEY (producer_id);
 B   ALTER TABLE ONLY public.producers DROP CONSTRAINT producers_pkey;
       public            postgres    false    216            �           2606    90434 *   product_categories product_categories_pkey 
   CONSTRAINT     {   ALTER TABLE ONLY public.product_categories
    ADD CONSTRAINT product_categories_pkey PRIMARY KEY (product_category_code);
 T   ALTER TABLE ONLY public.product_categories DROP CONSTRAINT product_categories_pkey;
       public            postgres    false    218            �           2606    90357    products products_pkey 
   CONSTRAINT     \   ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_pkey PRIMARY KEY (product_id);
 @   ALTER TABLE ONLY public.products DROP CONSTRAINT products_pkey;
       public            postgres    false    220            �           2606    90342    purchases purchases_pkey 
   CONSTRAINT     _   ALTER TABLE ONLY public.purchases
    ADD CONSTRAINT purchases_pkey PRIMARY KEY (purchase_id);
 B   ALTER TABLE ONLY public.purchases DROP CONSTRAINT purchases_pkey;
       public            postgres    false    219            �           2606    90310    workers workers_pkey 
   CONSTRAINT     Y   ALTER TABLE ONLY public.workers
    ADD CONSTRAINT workers_pkey PRIMARY KEY (worker_id);
 >   ALTER TABLE ONLY public.workers DROP CONSTRAINT workers_pkey;
       public            postgres    false    215            �           2606    90397 )   order_strings order_strings_order_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.order_strings
    ADD CONSTRAINT order_strings_order_id_fkey FOREIGN KEY (order_id) REFERENCES public.orders(order_id);
 S   ALTER TABLE ONLY public.order_strings DROP CONSTRAINT order_strings_order_id_fkey;
       public          postgres    false    222    221    3255            �           2606    90378    orders orders_client_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_client_id_fkey FOREIGN KEY (client_id) REFERENCES public.clients(client_id);
 F   ALTER TABLE ONLY public.orders DROP CONSTRAINT orders_client_id_fkey;
       public          postgres    false    3241    221    214            �           2606    90383 $   orders orders_order_status_code_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_order_status_code_fkey FOREIGN KEY (order_status_code) REFERENCES public.order_statuses(order_status_code);
 N   ALTER TABLE ONLY public.orders DROP CONSTRAINT orders_order_status_code_fkey;
       public          postgres    false    217    3247    221            �           2606    90373    orders orders_worker_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_worker_id_fkey FOREIGN KEY (worker_id) REFERENCES public.workers(worker_id);
 F   ALTER TABLE ONLY public.orders DROP CONSTRAINT orders_worker_id_fkey;
       public          postgres    false    3243    221    215            �           2606    90436 ,   products products_product_category_code_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_product_category_code_fkey FOREIGN KEY (product_category_code) REFERENCES public.product_categories(product_category_code);
 V   ALTER TABLE ONLY public.products DROP CONSTRAINT products_product_category_code_fkey;
       public          postgres    false    3249    218    220            �           2606    90411 2   purchase_strings purchase_strings_purchase_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.purchase_strings
    ADD CONSTRAINT purchase_strings_purchase_id_fkey FOREIGN KEY (purchase_id) REFERENCES public.purchases(purchase_id);
 \   ALTER TABLE ONLY public.purchase_strings DROP CONSTRAINT purchase_strings_purchase_id_fkey;
       public          postgres    false    219    3251    223            �           2606    90343 $   purchases purchases_producer_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.purchases
    ADD CONSTRAINT purchases_producer_id_fkey FOREIGN KEY (producer_id) REFERENCES public.producers(producer_id);
 N   ALTER TABLE ONLY public.purchases DROP CONSTRAINT purchases_producer_id_fkey;
       public          postgres    false    219    216    3245            Q   3   x�3�0���6\�qa7煩/6]���ͬH,.-J�08K�b���� T�[      T   x   x�U���0Dk2 �a�TT��PB$>a��F\R��w�s�`ņ�eS��`�9<���$Z�0��`�PSFGՅM&�*f��~|u�:�q��mpR��h����OHh3��*�}�      Y      x������ � �      X      x������ � �      S      x������ � �      U   ?   x�3�0���;.l���ˈ�´���.��2�0�®���^l��.6p��qqq kP'      W   �  x�}��jQ���<�f���̙��<�ިWމ %�ڂ�X�nҊ��j�P�R��ة�L_a�Wȓ�Τ�(67��f����*�1A��d�� S\Jv`�����όgU^�v����@T��*Ԛ��m�W���Z��V�W�<��_ݧk���2d\�|�o	�;
�߈�S�!�)�%��2�$P�!˴Zˀ�"�Ǿݱ�
.(�K��O���f�Dp@݄���F�u���?F��t��r<����8bk)CS���O�jƴ��(:�De���M�����C.����ݓ��ú�0:�)F���Jb�%��	�8���r���P�<��,�E���aC%FEK1�����Gn2B��-�r�r���~|���|�#+�_�dUAQq]����vn�U���Ut-������5���;�jnyNA�5��'͔��U�����V؊��������zlt׼���y��&�1      Z      x������ � �      V      x������ � �      R   �   x�31�0�¾��]�ě.̿��¦[/�V�0(���r�(���휆F��f�&f��e�E%�E�U�I�I٥���9zE��1~ ��e�ya��@M�ta�)6\l��s�l�Ŧ�/������������Ԍ383%�(�,1*?n(�VNcS��=... ɁY�     