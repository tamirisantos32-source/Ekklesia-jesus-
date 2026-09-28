# ⛪ Portal Ekklesia

Aplicação desenvolvida em **Flutter** e **Firebase** para gestão e acompanhamento de atividades comunitárias e da igreja.

---

## 🚀 Funcionalidades

- 🔐 **Autenticação com Firebase Auth:** Login seguro para membros e administradores.
- 📱 **Painel em Abas (MainTabNavigator):**
  - 🙏 **Worship** (Cultos e Louvor)
  - 🎂 **Birthdays** (Aniversariantes)
  - 💰 **Tithes** (Dízimos e Ofertas)
  - 📢 **Notices** (Avisos e Recados)
- ❤️ **Reações com Emojis:** Interação em tempo real com as publicações armazenadas no Cloud Firestore.
- 🛡️ **Controlo de Acesso por Perfil (Roles):** Botão de adição e formulário restritos a utilizadores administradores (`admin`).

---

## 📂 Estrutura do Projeto

```text
lib/
├── main.dart               # Ponto de entrada do projeto
└── screens/
    ├── login_screen.dart        # Ecrã de autenticação
    ├── main_tab_navigator.dart  # Navegação por abas
    └── content_view_page.dart   # Feed de publicações e reações
