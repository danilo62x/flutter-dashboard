# Flutter Dashboard

> Painel de analytics mobile em Flutter

[![Licença: MIT](https://img.shields.io/badge/Licen%C3%A7a-MIT-blue.svg)](./LICENSE) ![Grátis](https://img.shields.io/badge/pre%C3%A7o-Gr%C3%A1tis-brightgreen)

Painel de gestão (admin) em Flutter 3.44 + Material 3 para e-commerce/vendas, com 9 telas e tema claro/escuro: visão geral com KPIs, gráficos de barras/linha/rosca desenhados em CustomPaint, analytics por período, pedidos com busca e filtros, detalhe do pedido com timeline, clientes com segmentos e perfil, relatórios com mini-gráficos, notificações e configurações. Navegação por bottom bar + rotas go_router, arquitetura em camadas com MVVM, sem libs de charting nem imagens de rede.

## 🧱 Stack

- Flutter 3.44
- Dart 3
- Material 3
- go_router
- provider
- http

## ✨ Recursos

- Flutter 3.44 (último stable) via FVM
- Material 3 com tema claro e escuro
- Arquitetura em camadas (data/domain/ui) + MVVM
- Navegação declarativa com go_router
- Modelos com JSON (fromJson/toJson) + serviço http
- Cards de métrica, gráfico de barras e últimos pedidos
- Layout responsivo (mobile, tablet, desktop)
- Android · iOS · Web · Windows + testes de widget

## 🖥️ Telas

![Visão geral](screenshots/dashboard.png)
![Analytics](screenshots/dashboard-2.png)
![Pedidos](screenshots/dashboard-3.png)
![Detalhe do pedido](screenshots/dashboard-4.png)
![Clientes](screenshots/dashboard-5.png)
![Relatórios](screenshots/dashboard-6.png)

## 🚀 Como rodar

Requer o [Flutter SDK](https://docs.flutter.dev/get-started/install) instalado (canal stable).

```bash
flutter pub get
flutter run
```

Para rodar na web: `flutter run -d chrome`. Para gerar o APK: `flutter build apk`.

## ❤️ Apoie o projeto

Curtiu e quer ajudar a manter os templates gratuitos? Faça uma doação (escolha o valor e a forma de pagamento):

**➡️ https://template.dev.br/doar?template=flutter-dashboard**

## 🔗 Mais templates

Veja o catálogo completo (grátis e premium) em **https://template.dev.br**

## 📄 Licença

[MIT](./LICENSE) © 2026 Danilo Quinelato
