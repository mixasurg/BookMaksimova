from flask import Flask, render_template, request, redirect, url_for
from flask_sqlalchemy import SQLAlchemy
from flask_login import LoginManager, UserMixin, login_user, login_required, logout_user, current_user
from sqlalchemy import Column, ForeignKey, Integer, Text, func
from sqlalchemy.orm import relationship
import time, random, string, os

app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = 'postgresql://postgres:mixasurg@localhost/Miniatures_store'
app.config['SECRET_KEY'] = 'your_secret_key'
db = SQLAlchemy(app)
login_manager = LoginManager(app)
login_manager.login_view = 'login'

# Модель Миниатюры
class Miniature(db.Model):
    __tablename__ = 'Miniatures'
    miniature_ID = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.Text, nullable=False)
    kategory_id = db.Column(db.Text, db.ForeignKey('Kategory.kategory_id'))
    material_id = db.Column(db.Text, db.ForeignKey('Material.material_id'))
    photos_id = db.Column(db.Integer, db.ForeignKey('Photos.photos_ID'))
    artist_id = db.Column(db.Integer, db.ForeignKey('Users.user_id'))

    def __repr__(self):
        return f"<Product {self.name}>"
    

# Модель Пользователя
class User(UserMixin, db.Model):
    __tablename__ = 'Users'
    user_id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.Text, nullable=False)
    contact = db.Column(db.Text)
    username = db.Column(db.Text, nullable = False)
    password = db.Column(db.Text, nullable = False)
    is_artist = db.Column(db.Boolean, nullable = False)
    is_active = db.Column(db.Boolean, default=True)  # Добавляем атрибут is_active
    def get_id(self):
        return str(self.user_id)


# Модель Заказы
class Order(db.Model):
    __tablename__ = 'Orders'
    order_ID = db.Column(db.Integer, primary_key=True)
    customer_ID = db.Column(db.Integer, db.ForeignKey('Users.user_id'))
    status_id = db.Column(db.Integer, db.ForeignKey('Status.status_id'))
    order_date = db.Column(db.Date)
    completion_date = db.Column(db.Date)
    description = db.Column(db.Text)

# Модель Строки заказов
class OrderLine(db.Model):
    __tablename__ = 'Orders_row'
    order_ID = db.Column(db.Integer, db.ForeignKey('Order.order_ID'), primary_key=True)
    string_id = db.Column(db.Integer, primary_key=True)
    artist_ID = db.Column(db.Integer, db.ForeignKey('Users.user_id'))
    status_id = db.Column(db.Integer, db.ForeignKey('Status.status_id'))
    order_date = db.Column(db.Date)
    completion_date = db.Column(db.Date)
    description = db.Column(db.Text)
    amount = db.Column(db.Numeric)
    product_id = db.Column(db.Integer,db.ForeignKey('Miniatures.miniature_ID'))

# Модель Статусы
class Status(db.Model):
    __tablename__ = 'Status'
    status_id = db.Column(db.Integer, primary_key=True)
    status = db.Column(db.Text)

# Модель Материалы
class Material(db.Model):
    __tablename__ = 'Material'
    material_id = db.Column(db.Integer, primary_key=True)
    material = db.Column(db.Text)

# Модель Категории
class Kategory(db.Model):
    __tablename__ = 'Kategory'
    kategory_id = db.Column(db.Integer, primary_key=True)
    kategory = db.Column(db.Text)

# Модель Фото
class Photo(db.Model):
    __tablename__ = 'Photos'
    photos_ID = db.Column(db.Integer, primary_key=True)
    string_photo_id = db.Column(db.Integer, primary_key=True)
    URL = db.Column(db.Text)

def get_last_order_id():
    last_id = db.session.query(Order.order_ID).order_by(Order.order_ID.desc()).first()
    last_order_id = last_id if last_id else 0
    return last_order_id

def get_artist_id(miniature_id):
    miniature = Miniature.query.filter_by(miniature_ID=miniature_id).first()
    return miniature

def generate_unique_filename():
    timestamp = str(int(time.time()))  # Get the current timestamp as a string
    random_string = ''.join(random.choices(string.ascii_letters + string.digits, k=8))  # Generate a random string of 8 characters
    filename = timestamp + '_' + random_string + '.jpg'  # Combine the timestamp, random string, and file extension
    return filename

def get_last_photos_id():
    last_photo = db.session.query(Photo.photos_ID).order_by(Photo.photos_ID.desc()).first()
    last_photos_id = last_photo[0] if last_photo else 0
    return last_photos_id

def save_photo(photo):
    directory = 'static/photos'
    if not os.path.exists(directory):
        os.makedirs(directory)

    filename = generate_unique_filename()
    filepath = os.path.join(directory, filename)

    photo.save(filepath)

    photo_url = '/static/photos/' + filename
    return photo_url

@login_manager.user_loader
def load_user(user_id):
    return db.session.get(User, int(user_id))

@app.route('/')
def index():
    products = Miniature.query.all()
    for product in products:
        category = Kategory.query.get(product.kategory_id)
        product.category_name = category.kategory
        first_photo = Photo.query.filter_by(photos_ID=product.photos_id).first()
        if first_photo:
            product.first_photo_url = first_photo.URL
    return render_template('index.html', products=products)

@app.route('/register', methods=['GET', 'POST'])
def register():
    if request.method == 'POST':
        username = request.form['username']
        password = request.form['password']
        full_name = request.form['full_name']
        contact_info = request.form['contact_info']
        is_artist = 'is_artist' in request.form

        user = User(name=full_name, contact=contact_info, username=username, password=password, is_artist = is_artist)

        db.session.add(user)
        db.session.commit()

        return redirect(url_for('index'))

    return render_template('register.html')

@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        username = request.form['username']
        password = request.form['password']
        user = User.query.filter_by(username=username).first()
        if user and user.password == password:
            login_user(user)
            return redirect(url_for('index'))
        else:
            return 'Invalid username or password'
    return render_template('login.html')

@app.route('/logout')
@login_required
def logout():
    logout_user()
    return redirect(url_for('index'))

@app.route('/cart', methods=['GET', 'POST'])
@login_required
def cart():
    if request.method == 'POST':
        product_id = request.form['product_id']
        order_id = get_last_order_id() + 1
        order = Order(order_ID = order_id, customer_ID=current_user.user_id)
        db.session.add(order)
        db.session.commit()
        artist_id = int(get_artist_id(product_id))
        orderLine = OrderLine(order_ID = order_id, product_id = product_id, status_id = 1, artist_id = artist_id)
        db.session.add(orderLine)
        db.session.commit()
        
        return redirect(url_for('cart'))
    orders = Order.query.filter_by(user_id=current_user.id).all()
    products = [Miniature.query.get(order.product_id) for order in orders]
    return render_template('cart.html', products=products)

@app.route('/add_product', methods=['GET', 'POST'])
def add_product():
    if request.method == 'POST':
        name = request.form['name']
        kategory_id = int(request.form.get('kategory'))
        material_id = int(request.form.get('material'))
        photos = request.files.getlist('photos[]')
        photos_id = get_last_photos_id() + 1
        user = current_user.user_id

        for photo in photos:
        # Сохранение фотографии в хранилище и получение URL
            photo_url = save_photo(photo)
            new_photo = Photo(photos_ID = photos_id, URL=photo_url)
            db.session.add(new_photo)
            db.session.commit()

        new_product = Miniature(name=name, artist_id = user, kategory_id=kategory_id, material_id = material_id, photos_id = photos_id)

        db.session.add(new_product)
        db.session.commit()

        return redirect(url_for('index'))
    else:
        kategory = Kategory.query.all()
        materials = Material.query.all()
        return render_template('add_product.html', kategory=kategory, materials=materials)
    
if __name__ == '__main__':
    app.run(debug=True)
