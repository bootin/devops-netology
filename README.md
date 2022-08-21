# devops-netology
# DevOps-22
# Vitaliy Mednikov

1) **/.terraform/*
    Игнорировать директории .terraform и ее вложения во всех директориях из корневой рабочей папки 

2) *.tfstate
   *.tfstate.*
    Игнорирование всех файлов зканчивающиеся на .tfstate или имеющие в середине *.tfstate.

3) crash.log
   crash.*.log
    Игнорирование всех файлов вида crash.log или crash.*.log

4) *.tfvars
   *.tfvars.json
    Игнорировать файлы с расширением *.tfvars *.tfvars.json т.к. там могут храниться логины/пароли и другая "чувствительная" информация

5) override.tf
   override.tf.json
   *_override.tf
   *_override.tf.json
    Исключаються файлы вида выше или имеющие окончание *_override.tf и *_override.tf.json

6) .terraformrc
   terraform.rc
    Исключает файлы вида выше

#new line