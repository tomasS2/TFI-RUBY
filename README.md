# Requisitos previos

- Ruby 3.2.0 (o superior)
- Rails 8.0


# Pasos para iniciar la aplicación

1. Clonar el repositorio:

    ` git clone git@github.com:tomasS2/TFI-RUBY.git `

2. Instalar las dependencias:

    ` bundle install `

3. Inicializar la base de datos:

    ` rails db:create `

    ` rails db:migrate `

    ` rails db:seed `

4. Ejecutar servidor:

    ` rails s `

# Usuarios

- Administrador:
    - email: admin@admin.com
    - contraseña: 123123

- Gerente:
    - email: manager@manager.com
    - contraseña: 123123

- Empleado:
    - email: employee@employee.com
    - contraseña: 123123


# Dependencias utilizadas

Para la realización del trabajo se utilizaron las siguientes dependencias:
-   Devise -> Manejo de sesiones.

-   Rolify -> Cuestiones relacionadas a los roles y sus validaciones.

-   Bootstrap -> Diseño de la web.


# Decisiones de diseño

-   Un usuario puede tener más de un rol.
-   Existen productos con talles y productos sin talles. Los productos con talles manejan su stock de acuerdo al talle y los que no tienen talles, usan un stock global.
-   Hay categorías principales y subcategorías. Las categorías principales vienen predefinidas y las subcategorías se pueden crear y modificar. Deben estar asociadas a una categoría principal.


# ¿Cómo usar?

La aplicación cuenta con varios botones bastantes descriptivos que le facilitarán al usuario su uso. Puede notar, ni bien inicia la aplicación, que el boton de 'Iniciar sesión' se encuentra arriba a la izquierda de la pantalla, en la barra de navegación. Así como también los distintos botones que llevan a las pestañas donde se encuentran los productos registrados en el sistema. 

Una vez logueado, puede acceder a todo el repertorio de funcionalidades que brinda el sistema como, por ejemplo, registrar un nuevo usuario, un nuevo producto o agregar un producto al carrito para luego consumar una venta.

Cuando se inicia la aplicación por primera vez, puede ocurrir un error por un tema de archivos temporales. Con presionar CTRL + F5 se soluciona y no vuevle a ocurrir más.
