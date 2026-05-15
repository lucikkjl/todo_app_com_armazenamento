**1. Descrição**

* **Descrição do App:** Um aplicativo Flutter simples feito para aprender a salvar dados no celular. Ele demonstra o uso prático de três ferramentas de armazenamento (SharedPreferences, Hive e Secure Storage), simulando uma tela de configurações, um perfil de usuário que respeita a LGPD e a proteção de dados sensíveis.

---

**2. O que o aplicativo faz:**
* **Configurações:** Salva e lembra se o Modo Escuro está ligado, o Idioma escolhido (Português/Inglês) e se as Notificações estão ativas.
* **Perfil do Usuário:** Salva um perfil com 4 dados (Nome, E-mail, Data e Pontuação). Inclui um botão para apagar tudo (Direito ao Esquecimento da LGPD).
* **Segurança:** Gera e apaga um Token de autenticação seguro.
* **Migração:** Transforma automaticamente dados antigos do app no novo formato.

---

**3. Respostas da Atividade :**

* **Por que foi escolhido SharedPreferences para configurações?**
  Porque as configurações são dados muito simples, sim/não ou textos curtos. O SharedPreferences guarda isso no formato chave-valor de forma super leve e rápida, ideal para preferências de tela.

* **Por que foi escolhido Hive para o perfil do usuário?**
  Porque o perfil do usuário guarda um grupo de dados juntos (objeto complexo). O Hive é um banco NoSQL muito rápido que permite salvar esses objetos inteiros facilmente através de `TypeAdapters`.

* **Por que foi escolhido flutter_secure_storage para o token?**
  Porque o token é uma credencial secreta e não pode ser guardado em texto comum. O Secure Storage criptografa o dado usando a área protegida do próprio sistema do celular,sendo Androi ou iOS.