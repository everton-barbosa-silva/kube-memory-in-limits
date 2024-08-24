Estrutura do Projeto
```
meproject/
└── public/
    ├── index.html
    ├── script.js
    ├── style.css
    └── imagem-de-erro.png
└── server/
    └── script.sh
```
-------

public/index.html: Página HTML principal que carrega a interface do usuário.
public/script.js: Script JavaScript para buscar dados do servidor, tratar erros e implementar rolagem infinita.
public/style.css: Arquivo CSS para estilizar a interface.
public/imagem-de-erro.png: Imagem exibida em caso de erro.
server/script.sh: Script Bash que coleta dados sobre os pods no namespace especificado.

--------------------------------------

Pré-requisitos
Node.js e npm instalados em seu ambiente.
kubectl instalado e configurado para acessar o cluster Kubernetes.
jq instalado para manipulação de JSON no script Bash.
Servidor Web para hospedar o front-end (por exemplo, http-server do npm).

-----------------------------------

Como usar:

```
git clone https://github.com/seu-usuario/meproject.git
cd meproject
cd server
npm install
npm install -g http-server


```
Navegue até o diretório public e inicie o servidor web:

```
cd public
http-server
```

Abra seu navegador e navegue até http://localhost:8080 (ou a porta em que o servidor foi iniciado).

Utilize a interface:

A interface carrega automaticamente os dados dos pods e implementa uma rolagem infinita.
Em caso de erro, uma imagem será exibida.

Contribuição
Contribuições são bem-vindas! Sinta-se à vontade para abrir issues e enviar pull requests.



