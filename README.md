# Yape Mobile Challenge

El desafío consistió en desarrollar una app que, utilizando una API mock, permita al usuario visualizar recetas, filtrarlas por su nombre e ingredientes, ver los detalles de la misma y también su origen en un mapa.
Dicha app cuenta con tres pantallas:

1) Home (search bar + lista de recetas + lista de recetas favoritas).
2) Detalle de la receta (con su descripción, posibilidad de agregar a favoritos y previsualización de su origen en un mapa).
3) Visualización de mapa.

# Arquitectura

Se utilizó la arquitectura MVVM, ya que la misma permite separar de forma efectiva la vista (UIViewController + Views) de la lógica de negocio (ViewModel) al mismo tiempo
que mantiene los modelos lo más compactos posible.

Minimum iOS Version: 16.2 
Al utilizar la última version disponible del SO, es posible aprovechar al máximo las novedades de la plataforma.

# Dependencias

- AlamoFire: Para realizar pedidos al servidor.

# Screens

| Home View  | Detail View |  Map View  |
| ------------- | ------------- | -------------- |
| ![Screen1](https://user-images.githubusercontent.com/81202273/229406620-6a054212-6b7d-4ea4-a07c-5716ec7f7225.png)  | ![Screen2](https://user-images.githubusercontent.com/81202273/229406726-466af856-261c-4648-afa4-97d4c4f2b5db.png)  |  ![Screen3](https://user-images.githubusercontent.com/81202273/229406816-960c14f6-e2ee-4591-a67c-ced7a44cb308.png)  |
