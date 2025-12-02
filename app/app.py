from flask import (
    Flask, render_template, request, redirect,
    url_for, session
)
from flask_sqlalchemy import SQLAlchemy
from flask_login import (
    LoginManager, UserMixin, login_user,
    login_required, logout_user, current_user
)
from sqlalchemy.sql import func
from sqlalchemy.orm import relationship
from werkzeug.security import generate_password_hash, check_password_hash
from datetime import datetime
import time, random, string, os
from decimal import Decimal

app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = 'postgresql://postgres:postgres@localhost/HvostikMarket'
app.config['SECRET_KEY'] = 'your_secret_key'
db = SQLAlchemy(app)
login_manager = LoginManager(app)
login_manager.login_view = 'login'

class Role(db.Model):
    __tablename__ = 'roles'
    role_id = db.Column(db.Integer, primary_key=True)
    role_name = db.Column(db.Text, nullable=False, unique=True)
    description = db.Column(db.Text)


class Employee(db.Model):
    __tablename__ = 'employees'
    employee_id = db.Column(db.Integer, primary_key=True)
    role_id = db.Column(
        db.Integer,
        db.ForeignKey('roles.role_id'),
        nullable=False
    )
    login = db.Column(db.Text, nullable=False, unique=True)
    password_hash = db.Column(db.Text, nullable=False)

    role = relationship('Role')
    @property
    def is_worker(self):
        return True


class Customer(UserMixin, db.Model):
    """
    Покупатель = пользователь для Flask-Login (личный кабинет).
    Таблица 'customers' из документа.
    """
    __tablename__ = 'customers'
    customer_id = db.Column(db.Integer, primary_key=True)
    full_name = db.Column(db.Text, nullable=False)
    phone = db.Column(db.Text)
    email = db.Column(db.Text, unique=True)
    delivery_address = db.Column(db.Text)
    registered_at = db.Column(
        db.DateTime, nullable=False,
        server_default=func.now()
    )
    password_hash = db.Column(db.Text, nullable=False)

    orders = relationship('Order', back_populates='customer')

    def get_id(self):
        return str(self.customer_id)

    @property
    def is_worker(self):
        return False


class Category(db.Model):
    __tablename__ = 'categories'
    category_id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.Text, nullable=False, unique=True)
    description = db.Column(db.Text)

    products = relationship('Product', back_populates='category')


class Product(db.Model):
    __tablename__ = 'products'
    product_id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.Text, nullable=False)
    description = db.Column(db.Text)
    price = db.Column(db.Numeric(10, 2), nullable=False)
    quantity = db.Column(db.Integer, nullable=False, default=0)
    manufacturer = db.Column(db.Text)
    category_id = db.Column(
        db.Integer,
        db.ForeignKey('categories.category_id'),
        nullable=False
    )
    photo_url = db.Column(db.Text)

    category = relationship('Category', back_populates='products')

    # --- Совместимость со старыми шаблонами книжного магазина ---
    @property
    def product_name(self):
        return self.name

    @property
    def price_sale(self):
        """Раньше использовалась цена продажи, теперь просто price."""
        return self.price

    @property
    def cover(self):
        """Раньше поле называлось cover, теперь photo_url."""
        return self.photo_url

    @cover.setter
    def cover(self, value):
        self.photo_url = value


class OrderStatus(db.Model):
    __tablename__ = 'order_statuses'
    order_status_id = db.Column(db.Integer, primary_key=True)
    status_name = db.Column(db.Text, nullable=False, unique=True)
    description = db.Column(db.Text)

    orders = relationship('Order', back_populates='status')


class Order(db.Model):
    __tablename__ = 'orders'
    order_id = db.Column(db.Integer, primary_key=True)
    created_at = db.Column(
        db.DateTime,
        nullable=False,
        server_default=func.now()
    )
    order_status_id = db.Column(
        db.Integer,
        db.ForeignKey('order_statuses.order_status_id'),
        nullable=False
    )
    total_amount = db.Column(
        db.Numeric(10, 2),
        nullable=False,
        default=0
    )
    customer_id = db.Column(
        db.Integer,
        db.ForeignKey('customers.customer_id'),
        nullable=False
    )
    employee_id = db.Column(
        db.Integer,
        db.ForeignKey('employees.employee_id')
    )

    customer = relationship('Customer', back_populates='orders')
    status = relationship('OrderStatus', back_populates='orders')
    items = relationship(
        'OrderItem', back_populates='order',
        cascade='all, delete-orphan'
    )
    payments = relationship(
        'Payment', back_populates='order',
        cascade='all, delete-orphan'
    )


class OrderItem(db.Model):
    __tablename__ = 'order_items'
    order_item_id = db.Column(db.Integer, primary_key=True)
    order_id = db.Column(
        db.Integer,
        db.ForeignKey('orders.order_id'),
        nullable=False
    )
    product_id = db.Column(
        db.Integer,
        db.ForeignKey('products.product_id'),
        nullable=False
    )
    quantity = db.Column(db.Integer, nullable=False)
    price_per_unit = db.Column(db.Numeric(10, 2), nullable=False)
    total = db.Column(db.Numeric(10, 2), nullable=False)

    order = relationship('Order', back_populates='items')
    product = relationship('Product')


class PaymentMethod(db.Model):
    __tablename__ = 'payment_methods'
    payment_method_id = db.Column(db.Integer, primary_key=True)
    method_name = db.Column(db.Text, nullable=False, unique=True)
    description = db.Column(db.Text)

    payments = relationship('Payment', back_populates='method')


class PaymentStatus(db.Model):
    __tablename__ = 'payment_statuses'
    payment_status_id = db.Column(db.Integer, primary_key=True)
    status_name = db.Column(db.Text, nullable=False, unique=True)
    description = db.Column(db.Text)

    payments = relationship('Payment', back_populates='status')


class Payment(db.Model):
    __tablename__ = 'payments'
    payment_id = db.Column(db.Integer, primary_key=True)
    order_id = db.Column(
        db.Integer,
        db.ForeignKey('orders.order_id'),
        nullable=False
    )
    payment_method_id = db.Column(
        db.Integer,
        db.ForeignKey('payment_methods.payment_method_id'),
        nullable=False
    )
    payment_status_id = db.Column(
        db.Integer,
        db.ForeignKey('payment_statuses.payment_status_id'),
        nullable=False
    )
    payment_date = db.Column(db.DateTime, nullable=False)
    amount = db.Column(db.Numeric(10, 2), nullable=False)

    order = relationship('Order', back_populates='payments')
    method = relationship('PaymentMethod', back_populates='payments')
    status = relationship('PaymentStatus', back_populates='payments')


class DeliveryMethod(db.Model):
    __tablename__ = 'delivery_methods'
    delivery_method_id = db.Column(db.Integer, primary_key=True)
    method_name = db.Column(db.Text, nullable=False, unique=True)
    description = db.Column(db.Text)


class DeliveryStatus(db.Model):
    __tablename__ = 'delivery_statuses'
    delivery_status_id = db.Column(db.Integer, primary_key=True)
    status_name = db.Column(db.Text, nullable=False, unique=True)
    description = db.Column(db.Text)


class Delivery(db.Model):
    __tablename__ = 'delivery'
    delivery_id = db.Column(db.Integer, primary_key=True)
    order_id = db.Column(
        db.Integer,
        db.ForeignKey('orders.order_id'),
        nullable=False
    )
    delivery_address = db.Column(db.Text, nullable=False)
    delivery_method_id = db.Column(
        db.Integer,
        db.ForeignKey('delivery_methods.delivery_method_id'),
        nullable=False
    )
    delivery_status_id = db.Column(
        db.Integer,
        db.ForeignKey('delivery_statuses.delivery_status_id'),
        nullable=False
    )
    shipped_date = db.Column(db.DateTime)
    received_date = db.Column(db.DateTime)
    employee_id = db.Column(
        db.Integer,
        db.ForeignKey('employees.employee_id')
    )

def generate_unique_filename():
    timestamp = str(int(time.time()))
    random_string = ''.join(
        random.choices(string.ascii_letters + string.digits, k=8)
    )
    filename = timestamp + '_' + random_string + '.jpg'
    return filename


def save_photo(photo):
    directory = 'static/cover'
    if not os.path.exists(directory):
        os.makedirs(directory)

    filename = generate_unique_filename()
    filepath = os.path.join(directory, filename)
    photo.save(filepath)
    photo_url = '/static/cover/' + filename
    return photo_url


CART_SESSION_KEY = 'cart'


def get_cart():
    """
    Корзина хранится в session как словарь {product_id: qty}
    """
    return session.get(CART_SESSION_KEY, {})


def save_cart(cart_dict):
    session[CART_SESSION_KEY] = cart_dict
    session.modified = True


@login_manager.user_loader
def load_user(user_id):
    # Для Flask-Login используем только покупателей (customers)
    return db.session.get(Customer, int(user_id))

# ------------------ РОУТЫ ------------------


@app.route('/')
def index():
    """
    Главная — вывод всех товаров.
    """
    products = Product.query.all()
    # Для удобства сразу подложим категорию
    return render_template('index.html', products=products)


# --------- Регистрация / вход / выход ----------

@app.route('/register', methods=['GET', 'POST'])
def register():
    """
    Регистрация покупателя.
    Форма должна содержать:
    - full_name
    - email
    - phone
    - delivery_address
    - password
    """
    if request.method == 'POST':
        full_name = request.form['full_name']
        email = request.form.get('email')
        phone = request.form.get('phone')
        delivery_address = request.form.get('delivery_address')
        password = request.form['password']

        if Customer.query.filter_by(email=email).first():
            return "Пользователь с таким email уже существует"

        customer = Customer(
            full_name=full_name,
            email=email,
            phone=phone,
            delivery_address=delivery_address,
            password_hash=generate_password_hash(password)
        )
        db.session.add(customer)
        db.session.commit()
        login_user(customer)
        return redirect(url_for('index'))

    return render_template('register.html')


@app.route('/login', methods=['GET', 'POST'])
def login():
    """
    Вход покупателя в личный кабинет.
    Форма: email, password
    """
    if request.method == 'POST':
        email = request.form['email']
        password = request.form['password']

        user = Customer.query.filter_by(email=email).first()
        if user and check_password_hash(user.password_hash, password):
            login_user(user)
            return redirect(url_for('index'))
        else:
            return 'Неверный email или пароль'

    return render_template('login.html')


@app.route('/logout')
@login_required
def logout():
    logout_user()
    save_cart({})
    return redirect(url_for('index'))


# --------- Личный кабинет / заказы ----------

@app.route('/account')
@login_required
def account():
    """
    Личный кабинет: данные покупателя и список его заказов.
    """
    orders = (
        Order.query
        .filter_by(customer_id=current_user.customer_id)
        .order_by(Order.created_at.desc())
        .all()
    )
    return render_template(
        'account.html',
        customer=current_user,
        orders=orders
    )


@app.route('/orders/<int:order_id>')
@login_required
def order_detail(order_id):
    """
    Детализация одного заказа: товары, суммы, оплата.
    """
    order = (
        Order.query
        .filter_by(order_id=order_id,
                  customer_id=current_user.customer_id)
        .first_or_404()
    )
    return render_template('order_detail.html', order=order)


# --------- Корзина и оформление ----------

@app.route('/cart')
@login_required
def cart():
    """
    Страница корзины:
    - список товаров
    - общая сумма
    - выбор способа оплаты
    """
    cart_dict = get_cart()
    if not cart_dict:
        products = []
        cart_items = []
        total = Decimal('0.00')
    else:
        product_ids = [int(pid) for pid in cart_dict.keys()]
        products = Product.query.filter(
            Product.product_id.in_(product_ids)
        ).all()
        cart_items = []
        total = Decimal('0.00')
        id_to_qty = {int(pid): qty for pid, qty in cart_dict.items()}

        for p in products:
            qty = id_to_qty.get(p.product_id, 0)
            line_total = p.price * qty
            total += line_total
            cart_items.append({
                'product': p,
                'quantity': qty,
                'line_total': line_total
            })

    payment_methods = PaymentMethod.query.all()
    delivery_methods = DeliveryMethod.query.all()
    return render_template(
        'cart.html',
        cart_items=cart_items,
        total=total,
        payment_methods=payment_methods,
        delivery_methods=delivery_methods,
    )


@app.route('/add_cart', methods=['POST'])
@login_required
def add_cart():
    """
    Добавление товара в корзину.
    В форме должен быть скрытый input name="product_id".
    """
    product_id = request.form['product_id']
    cart_dict = get_cart()
    cart_dict[product_id] = cart_dict.get(product_id, 0) + 1
    save_cart(cart_dict)
    return redirect(url_for('index'))


@app.route('/remove_from_cart', methods=['POST'])
@login_required
def remove_from_cart():
    """
    Удаление товара из корзины (по желанию).
    """
    product_id = request.form['product_id']
    cart_dict = get_cart()
    if product_id in cart_dict:
        cart_dict.pop(product_id)
        save_cart(cart_dict)
    return redirect(url_for('cart'))

@app.route('/check', methods=['POST'])
@login_required
def check():
    """
    Оформление заказа (checkout).

    Из формы корзины ожидаются:
    - payment_method_id  : выбранный способ оплаты
    - delivery_method_id : выбранный способ доставки
    - delivery_address   : адрес доставки (по умолчанию подставляется
                           из current_user.delivery_address, но можно изменить)
    """
    cart_dict = get_cart()
    if not cart_dict:
        # Если корзина пуста — возвращаем на страницу корзины
        return redirect(url_for('cart'))

    # --- Чтение данных из формы ---
    try:
        payment_method_id = int(request.form['payment_method_id'])
        delivery_method_id = int(request.form['delivery_method_id'])
    except (KeyError, ValueError):
        # Если чего-то нет или не число — вернём на корзину
        # (можно ещё flash-сообщение добавить)
        return redirect(url_for('cart'))

    # Адрес: либо из формы, либо тот, что сохранён у пользователя
    delivery_address = request.form.get('delivery_address') or current_user.delivery_address

    # --- Готовим данные по товарам ---
    product_ids = [int(pid) for pid in cart_dict.keys()]
    products = Product.query.filter(Product.product_id.in_(product_ids)).all()
    id_to_product = {p.product_id: p for p in products}

    total_amount = Decimal('0.00')
    for pid_str, qty in cart_dict.items():
        pid = int(pid_str)
        product = id_to_product[pid]
        total_amount += product.price * qty

    # --- Статусы по умолчанию ---

    # Статус "Новый" для заказа
    order_status = OrderStatus.query.filter_by(status_name='Новый').first()
    order_status_id = order_status.order_status_id if order_status else 1

    # Статус "Ожидает оплаты" для платежа
    payment_status = PaymentStatus.query.filter_by(status_name='Ожидает оплаты').first()
    payment_status_id = payment_status.payment_status_id if payment_status else 1

    # Статус "Создано" для доставки
    delivery_status = DeliveryStatus.query.filter_by(status_name='Создано').first()
    delivery_status_id = delivery_status.delivery_status_id if delivery_status else 1

    # --- Создаём заказ ---
    order = Order(
        customer_id=current_user.customer_id,
        order_status_id=order_status_id,
        total_amount=total_amount
    )
    db.session.add(order)
    db.session.flush()  # получаем order.order_id

    # --- Строки заказа (OrderItem) ---
    for pid_str, qty in cart_dict.items():
        pid = int(pid_str)
        product = id_to_product[pid]
        line_total = product.price * qty

        item = OrderItem(
            order_id=order.order_id,
            product_id=pid,
            quantity=qty,
            price_per_unit=product.price,
            total=line_total
        )
        db.session.add(item)

        # уменьшаем остаток на складе
        if product.quantity is not None:
            product.quantity = product.quantity - qty

    # --- Платёж ---
    payment = Payment(
        order_id=order.order_id,
        payment_method_id=payment_method_id,
        payment_status_id=payment_status_id,
        payment_date=datetime.utcnow(),
        amount=total_amount
    )
    db.session.add(payment)

    # --- Доставка ---
    delivery = Delivery(
        order_id=order.order_id,
        delivery_address=delivery_address,
        delivery_method_id=delivery_method_id,
        delivery_status_id=delivery_status_id
    )
    db.session.add(delivery)

    # Если пользователь поменял адрес доставки — обновим его в профиле
    if hasattr(current_user, 'delivery_address') and delivery_address and current_user.delivery_address != delivery_address:
        current_user.delivery_address = delivery_address

    # --- Сохраняем все изменения ---
    db.session.commit()

    # --- Очищаем корзину ---
    save_cart({})

    return redirect(url_for('order_detail', order_id=order.order_id))


# --------- Добавление товара (админка) ----------

@app.route('/add_product', methods=['GET', 'POST'])
@login_required
def add_product():
    """
    Простая форма добавления товара.
    По-хорошему, доступ ограничить только админу, но сейчас достаточно login_required.
    """
    if request.method == 'POST':
        name = request.form['name']
        description = request.form.get('description')
        price = Decimal(request.form.get('price', '0'))
        quantity = int(request.form.get('quantity', 0))
        manufacturer = request.form.get('manufacturer')
        category_id = int(request.form.get('category_id'))

        photos = request.files.getlist('cover[]')
        photo_url = None
        for photo in photos:
            if photo and photo.filename:
                photo_url = save_photo(photo)

        new_product = Product(
            name=name,
            description=description,
            price=price,
            quantity=quantity,
            manufacturer=manufacturer,
            category_id=category_id,
            photo_url=photo_url
        )

        db.session.add(new_product)
        db.session.commit()

        return redirect(url_for('index'))
    else:
        categories = Category.query.all()
        return render_template(
            'add_product.html',
            categories=categories
        )


if __name__ == '__main__':
    app.run(debug=True)
