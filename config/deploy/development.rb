set :stage, :development
role :app, %w{root@133.167.45.38}
role :web, %w{root@133.167.45.38}
role :db, %w{root@133.167.45.38}

server '133.167.45.38',
user: 'root',
roles: %w{web app db},
ssh_options: {
 auth_methods: %w(password),
 password: '********'
}
