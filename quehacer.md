# orden de cosas por hacer según ganas:


tenes en cuenta en las tablas: si no hay registros creados, hacer que se oculte la tabla y ponga un mensaje


## Usuarios

## Productos
https://www.youtube.com/watch?v=wLCDFQuCsbg&list=PL2PkZdv6p7ZmNLdSsQgCn6lYhd3aZjcyl -> para el index de los productos
https://www.youtube.com/watch?v=kXaCfXUNsAw -> para el show de los productos
https://github.com/coderdost/BootStrap-Ecommerce/blob/master/product.html repositorio del indio
hacer los filtros de las categorías e implementar el buscar por descripción y/o nombre (fijarse)
ver como mostrar el stock size del prodcuto
validaciones en el stock de los talles y que no se puedan ingresar talles negativos

ver a donde volver en el breadcrumb cuando voy desde tal o tal vista.

## Ventas
hacer modelo carrito, carrito_item, venta, venta_item.



## correcciones profesor
-El Readme está escueto, le falta indicar dependencias que agregaste, decisiones de diseño importantes, requisitos, cómo preparar e iniciar la aplicación, etc.

-Algunos modelos necesitan más validaciones.

-UsersController tiene muchísima lógica que en realidad pertenece al modelo. Recordá que los controllers debieran delegar en los modelos cuestiones que tengan que ver con la lógica de negocios. Por ejemplo, el controller debería chequear si el usuario realizando determinada acción tiene el rol requerido, pero la acción de cambio de estado interna del objeto sobre el cual se realiza la operación debería ser realizada por el objeto mismo (no el controller). Eso es principalmente porque las abstracciones (como los modelos, por ejemplo) no deberían revelar su estado interno.

-De manera similar al punto anterior, ProductsController maneja mucho estado interno de los modelos Product y ProductSize.

-El módulo Registerable de Devise no debería estar habilitado.