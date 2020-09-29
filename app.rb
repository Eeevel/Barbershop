require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'
require 'pony'

configure do
  db = SQLite3::Database.new 'barbershop.db'
  db.execute 'CREATE TABLE IF NOT EXISTS "Users"
    (
      "id" INTEGER PRIMARY KEY AUTOINCREMENT,
      "username" TEXT,
      "phone" TEXT,
      "datestamp" TEXT,
      "barber" TEXT,
      "color" TEXT
    )'
  db.close
end

get '/' do
	erb "Hello! <a href=\"https://github.com/bootstrap-ruby/sinatra-bootstrap\">Original</a> pattern has been modified for <a href=\"http://rubyschool.us/\">Ruby School</a>"			
end

get '/about' do
	erb :about
end

get '/visit' do
	erb :visit
end

get '/contacts' do
  erb :contacts
end

post '/visit' do
  @user_name = params[:user_name]
  @phone = params[:phone]
  @datetime = params[:datetime]
  @master_name = params[:master_name]
  @color = params[:color]

  #Валидация
  hh = { :user_name => 'Введите имя',
         :phone => 'Введите телефон',
         :datetime => 'Введите дату и время' }

  @error = hh.select {|key, value| params[key] == ''}.values.join(', ')
  if @error != ''
    return erb :visit
  end
  @error = NIL

  #Сохранение в базу данных
  db = SQLite3::Database.new 'barbershop.db'
  db.execute 'INSERT INTO Users (username, phone, datestamp, barber, color)
  VALUES (?, ?, ?, ?, ?)', [@user_name, @phone, @datetime, @master_name, @color]
  db.close

  #Запись в файл
  file_users = File.open './public/users.txt', 'a'
  file_users.write "Клиент: #{@user_name}, Телефон: #{@phone}, Мастер: #{@master_name}, Дата и время: #{@datetime}.\n"
  file_users.close

  @message = "Дорогой #{@user_name}, #{@master_name} будет ожидать вас #{@datetime}."

  erb :visit
end

post '/contacts' do
  @user_name = params[:user_name]
  @email = params[:email]
  @report = params[:report]

  #Валидация
  hh = { :user_name => 'Введите имя',
         :email => 'Введите email',
         :report => 'Введите сообщение' }

  @error = hh.select {|key, value| params[key] == ''}.values.join(', ')
  if @error != ''
    return erb :contacts
  end
  @error = NIL

  #Запись в файл
  file_reports = File.open './public/reports.txt', 'a'
  file_reports.write "Клиент: #{@user_name}, Email: #{@email}, Сообщение: #{@report}.\n"
  file_reports.close

  @message = "Дорогой #{@user_name}, ваше сообщение отправлено"

  erb :contacts
end

#разобраться с бутстрапом для 21 урока. скорее всего
# нужно скачать шаблон из гитахаба того челика и все делать в нем (в итоге у него синатра
# 2.0 и 4 бутстрап. 4 бутстрап мне не особо нужен, а 2 синатра особо не отличается от 1.4
# поэтому остаюсь на этой версии)
# 1 попробовать сделать кастомную сборку проекта из .рб файла челика и бутстрапа
# 2 если не получился кастом, то скачать шаблон челика
# 3 разобраться  с бутстрапом