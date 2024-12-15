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
    password: '123456',
    username: 'admin',
    phone_number: '221 123456',
)
admin_user.add_role(:admin) 


puts "Creando manager"

manager_user = User.create!(
    email: 'manager@manager.com',
    password: '123456',
    username: 'manager',
    phone_number: '221 123456',
)
manager_user.add_role(:manager)  


puts "Creando empleado"
 
employee_user = User.create!(
    email: 'employee@employee.com',
    password: '123456',
    username: 'employee',
    phone_number: '221 123456',
)
employee_user.add_role(:employee)  


puts "Creando Superusuario"

super_user = User.create!(
    email: 'super@super.com',
    password: '123456',
    username: 'super',
    phone_number: '221 123456',
)
super_user.add_role(:admin)  
super_user.add_role(:manager)  
super_user.add_role(:employee)  

puts "Usuarios y roles creados"
