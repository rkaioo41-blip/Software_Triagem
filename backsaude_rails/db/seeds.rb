# db/seeds.rb

require 'faker'

especialidades = [
  "Clínico Geral", "Pediatria", "Cardiologia", "Ortopedia",
  "Dermatologia", "Neurologia", "Ginecologia", "Psiquiatria"
]

# Turnos fixos de 4h
turnos = [
  [ "08:00", "12:00" ],
  [ "12:00", "16:00" ],
  [ "16:00", "20:00" ],
  [ "20:00", "00:00" ],
  [ "00:00", "04:00" ],
  [ "04:00", "08:00" ]
]

24.times do |i|
  nome = Faker::Name.name
  crm = "CRM#{rand(1000..9999)}"
  email = Faker::Internet.email(name: nome.parameterize)
  especialidade = especialidades.sample

  inicio, fim = turnos[i % turnos.size]

  Medico.create!(
    nome: nome,
    CRM: crm,
    email: email,
    especialidade: especialidade,
    hora_inicio: inicio,
    hora_fim: fim
  )
end

puts "✅ Banco de médicos populado com #{Medico.count} registros!"
