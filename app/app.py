from flask import Flask, render_template, request, redirect, url_for
from flask_sqlalchemy import SQLAlchemy
from flask_login import LoginManager, UserMixin, login_user, login_required, logout_user, current_user
from sqlalchemy import Column, ForeignKey, Integer, Text, func
from sqlalchemy.orm import relationship
import time, random, string, os
from datetime import datetime

app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = 'postgresql://postgres:mixasurg@localhost/Book_store_maksimova'
app.config['SECRET_KEY'] = 'your_secret_key'
db = SQLAlchemy(app)
login_manager = LoginManager(app)
login_manager.login_view = 'login'

# Модель Продуктов
class Products(db.Model):
    __tablename__ = 'products'
    product_id = db.Column(db.Integer, primary_key=True)
    product_name = db.Column(db.Text, nullable=False)
    price_purchase = db.Column(db.Integer, nullable=False)
    price_sale = db.Column(db.Integer, nullable=False)
    # product_category_code = db.Column(db.Integer, db.ForeignKey('Product_Categories.product_category_code'), nullable=False)
    product_category_code = db.Column(db.Integer, db.ForeignKey('product_categories.product_category_code'), nullable=False)
    cover = db.Column(db.Text)

    def __repr__(self):
        return f"<Products {self.name}>"
    

# Модель Пользователя
class Client(UserMixin, db.Model):
    __tablename__ = 'clients'
    client_id = db.Column(db.Integer, primary_key=True)
    client_name = db.Column(db.Text, nullable=False)
    client_email = db.Column(db.Text)
    username = db.Column(db.Text, nullable = False)
    password = db.Column(db.Text, nullable = False)
    is_active = db.Column(db.Boolean, default=True) 
    client_cart = [] 
    def get_id(self):
        return str(self.client_id)
    
# Модель Работника
class Worker(UserMixin, db.Model):
    __tablename__ = 'workers'
    worker_id = db.Column(db.Integer, primary_key=True)
    worker_name = db.Column(db.Text, nullable=False)
    username = db.Column(db.Text, nullable = False)
    password = db.Column(db.Text, nullable = False)
    is_active = db.Column(db.Boolean, default=True) 
    is_worker = True  
    client_cart = [] 
    def get_id(self):
        return str(self.worker_id)

# Модель Заказы
class Order(db.Model):
    __tablename__ = 'orders'
    order_id = db.Column(db.Integer, primary_key=True)
    client_id = db.Column(db.Integer, db.ForeignKey('clients.client_id'))
    worker_id = db.Column(db.Integer, db.ForeignKey('workers.worker_id'))
    order_status_code = db.Column(db.Integer, db.ForeignKey('order_statuses.order_status_code'))
    creation_data = db.Column(db.TIMESTAMP, nullable=False)
    performance_data = db.Column(db.TIMESTAMP, nullable=False)

# Модель Строки заказов
class OrderLine(db.Model):
    __tablename__ = 'order_strings'
    order_id = db.Column(db.Integer, db.ForeignKey('Orders.order_id'), primary_key=True)
    row_number = db.Column(db.Integer, primary_key=True)
    product_amount = db.Column(db.Numeric)
    product_id = db.Column(db.Integer,db.ForeignKey('Products.product_id'))

# Модель Статусы
class Order_statuses(db.Model):
    __tablename__ = 'order_statuses'
    order_status_code = db.Column(db.Integer, primary_key=True)
    order_status = db.Column(db.Text)

# Модель Категории
class Product_Categories(db.Model):
    __tablename__ = 'product_categories'
    product_category_code = db.Column(db.Integer, primary_key=True)
    product_category  = db.Column(db.Text)

def get_last_order_id():
    last_id = db.session.query(Order.order_id).order_by(Order.order_id.desc()).first()
    last_order_id = last_id if last_id else 0
    return last_order_id

def generate_unique_filename():
    timestamp = str(int(time.time()))  # Get the current timestamp as a string
    random_string = ''.join(random.choices(string.ascii_letters + string.digits, k=8))  # Generate a random string of 8 characters
    filename = timestamp + '_' + random_string + '.jpg'  # Combine the timestamp, random string, and file extension
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

@login_manager.user_loader
def load_user(client_id):
    return db.session.get(Client, int(client_id))

# s

@app.route('/')
def index():
    products = Products.query.all()
    for product in products:
        category = Product_Categories.query.get(product.product_category_code)
        product.category_name = category.product_category
    return render_template('index.html', products=products)

@app.route('/register', methods=['GET', 'POST'])
def register():
    if request.method == 'POST':
        username = request.form['username']
        password = request.form['password']
        full_name = request.form['full_name']
        contact_info = request.form['contact_info']

        user = Client(client_name=full_name, client_email=contact_info, username=username, password=password)

        db.session.add(user)
        db.session.commit()

        return redirect(url_for('index'))

    return render_template('register.html')

@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        username = request.form['username']
        password = request.form['password']
        user = Client.query.filter_by(username=username).first()
        if user and user.password == password:
            login_user(user)
            return redirect(url_for('index'))
        else:
            return 'Invalid username or password'
    return render_template('login.html')

@app.route('/login_worker', methods=['GET', 'POST'])
def login_worker():
    if request.method == 'POST':
        username = request.form['username']
        password = request.form['password']
        user = Worker.query.filter_by(username=username).first()
        if user and user.password == password:
            login_user(user)
            return redirect(url_for('index'))
        else:
            return 'Invalid username or password'
    return render_template('login_worker.html')

@app.route('/logout')
@login_required
def logout():
    logout_user()
    return redirect(url_for('index'))

@app.route('/cart', methods=['GET', 'POST'])
@login_required
def cart():
    product_ids = current_user.client_cart
    products = Products.query.filter(Products.product_id.in_(product_ids)).all()
    for product in products:
        category = Product_Categories.query.get(product.product_category_code)
        product.category_name = category.product_category
        product.quantity = 1
    return render_template('cart.html', products=products)

@app.route('/add_cart', methods=['POST'])
@login_required
def add_cart():
    if request.method == 'POST':
        product_id = request.form['product_id']
        current_user.client_cart.append(product_id)
    return redirect(url_for('index'))

@app.route('/check', methods=['POST'])
@login_required
def check():
    if request.method == 'POST':
        product_ids = current_user.client_cart
        product_amount = int(request.form.get('productCount', 1)) 
        order_id = get_last_order_id() + 1
        order = Order(order_id=order_id, client_id=current_user.client_id, order_status_code=1, creation_data=datetime.now())
        db.session.add(order)
        db.session.commit()
        for product_id in product_ids:
            order_line = OrderLine(order_id=order_id, product_id=product_id, product_amount=product_amount)
            db.session.add(order_line)
            db.session.commit()
        
        return redirect(url_for('cart'))

@app.route('/add_product', methods=['GET', 'POST'])
def add_product():
    if request.method == 'POST':
        name = request.form['name']
        product_category_code = int(request.form.get('kategory'))
        price_purchase = int(request.form.get('pursh'))
        price_sale = int(request.form.get('sale'))
        
        photos = request.files.getlist('cover[]')
        photo_url = ''
        for photo in photos:
            photo_url = save_photo(photo)
        
        print(photo_url)
        new_product = Products(product_name=name, price_purchase =price_purchase, price_sale = price_sale, product_category_code=product_category_code, cover = photo_url)

        db.session.add(new_product)
        db.session.commit()

        return redirect(url_for('index'))
    else:
        kategory = Product_Categories.query.all()
        return render_template('add_product.html', kategory=kategory)
    
if __name__ == '__main__':
    app.run(debug=True)
