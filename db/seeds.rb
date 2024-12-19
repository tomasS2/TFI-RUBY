puts "Borrando usuarios y roles..."

User.find_each do |user|
    user.roles.clear
  end
User.delete_all
Role.delete_all

puts "Usuarios y roles borrados"

puts "Creando roles"

admin = Role.create!(
    id: 1,
    name: "admin",
)

manager = Role.create!(
    id: 2,
    name: "manager",
)

employee = Role.create!(
    id: 3,
    name: "employee",
)


puts "Creando admin"

admin_user = User.create!(
    email: 'admin@admin.com',
    password: '123123',
    username: 'admin',
    phone_number: '221 123456',
)
admin_user.add_role(:admin) 


puts "Creando manager"

manager_user = User.create!(
    email: 'manager@manager.com',
    password: '123123',
    username: 'manager',
    phone_number: '221 123456',
)
manager_user.add_role(:manager)  


puts "Creando empleado"
 
employee_user = User.create!(
    email: 'employee@employee.com',
    password: '123123',
    username: 'employee',
    phone_number: '221 123456',
)
employee_user.add_role(:employee)  


puts "Creando Superusuario"

super_user = User.create!(
    email: 'super@super.com',
    password: '123123',
    username: 'super',
    phone_number: '221 123456',
)
super_user.add_role(:admin)  
super_user.add_role(:manager)  
super_user.add_role(:employee)  

puts "Usuarios y roles creados"


puts "Borrando productos"

Product.delete_all

puts "Borrando categorías"

Category.delete_all

puts "Borrando talles"

ProductSize.delete_all

Size.delete_all

puts "Creando categorías"

categoria_zapatilla = Category.create!(
    id: 1,
    category_name: "Zapatilla",
)

categoria_campera = Category.create!(
    id: 2,
    category_name: "Campera",
)

categoria_pantalon = Category.create!(
    id: 3,
    category_name: "Pantalón",
)

puts "Creando talles"


10.times do |i|
    Size.create!(
        size_value: "#{i+35}"
    )
end

talle_s = Size.create!(
    size_value: "s",
)
talle_m = Size.create!(
    size_value: "m",
)
talle_l = Size.create!(
    size_value: "l",
)
talle_xl = Size.create!(
    size_value: "xl",
)

puts "Creando productos"

campera = Product.new(
    name: "Campera adidas",
    description: "Diseñada para el frío",
    price: 100,
    stock: 123,
    colour: "Rojo",
    category_id: 3,
  )

campera.images.attach(io: File.open(Rails.root.join('app', 'assets', 'images', 'campera_adidas.jpg')), filename: 'campera_adidas.jpg')
ProductSize.create!(product: campera, size: talle_s, product_size_stock: 50)
ProductSize.create!(product: campera, size: talle_m, product_size_stock: 20)
ProductSize.create!(product: campera, size: talle_l, product_size_stock: 100)
ProductSize.create!(product: campera, size: talle_xl, product_size_stock: 0)
campera.save!


pantalon = Product.new(
    name: "Pantalón adidas",
    description: "Diseñada para las piernas",
    price: 200,
    stock: 5,
    colour: "Negro",
    category_id: 2,
  )

pantalon.images.attach(io: File.open(Rails.root.join('app', 'assets', 'images', 'pantalon_adidas.jpg')), filename: 'pantalon_adidas.jpg')
pantalon.images.attach(io: File.open(Rails.root.join('app', 'assets', 'images', 'pantalon_adidas2.jpg')), filename: 'pantalon_adidas2.jpg')
ProductSize.create!(product: pantalon, size: talle_s, product_size_stock: 10)
ProductSize.create!(product: pantalon, size: talle_m, product_size_stock: 0)
ProductSize.create!(product: pantalon, size: talle_l, product_size_stock: 19)
ProductSize.create!(product: pantalon, size: talle_xl, product_size_stock: 0)
pantalon.save!


zapatilla = Product.new(
    name: "Zapatillas adidas",
    description: "Diseñada para los pies",
    price: 500,
    stock: 2,
    colour: "Celeste",
    category_id: 1,
  )

zapatilla.images.attach(io: File.open(Rails.root.join('app', 'assets', 'images', 'zapatillas_adidas.jpg')), filename: 'zapatillas_adidas.jpg')
10.times do |i|
    ProductSize.create!(product: zapatilla, size: Size.find_by(size_value: "#{i+35}"), product_size_stock: i)
end
zapatilla.save!
