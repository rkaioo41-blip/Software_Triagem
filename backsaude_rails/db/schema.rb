# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_09_10_031352) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "classificacao_riscos", force: :cascade do |t|
    t.string "nivel", null: false
    t.string "nome_nivel", null: false
    t.string "tempo_atendimento", null: false
    t.text "descricao"
    t.jsonb "exemplos", default: [], null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["nivel"], name: "index_classificacao_riscos_on_nivel", unique: true
  end

  create_table "enfermeiros", force: :cascade do |t|
    t.string "nome"
    t.date "data_nascimento"
    t.string "cpf"
    t.string "sexo"
    t.string "email"
    t.string "coren"
    t.string "uf"
    t.string "instituicao"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.index ["coren"], name: "index_enfermeiros_on_coren", unique: true
    t.index ["cpf"], name: "index_enfermeiros_on_cpf", unique: true
    t.index ["email"], name: "index_enfermeiros_on_email", unique: true
    t.index ["reset_password_token"], name: "index_enfermeiros_on_reset_password_token", unique: true
  end

  create_table "medicos", force: :cascade do |t|
    t.string "nome"
    t.string "CRM"
    t.string "email"
    t.time "hora_inicio"
    t.time "hora_fim"
    t.string "especialidade"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "paciente_fakes", force: :cascade do |t|
    t.string "codigo_sus"
    t.string "nome"
    t.string "cpf"
    t.string "sexo"
    t.string "endereco"
    t.date "data_nascimento"
    t.string "cidade"
    t.string "nome_pai"
    t.string "nome_mae"
    t.string "raca_cor"
    t.string "orientacao_sexual"
    t.string "identidade_genero"
    t.string "nome_social"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "relatorio_triagems", force: :cascade do |t|
    t.bigint "paciente_fake_id", null: false
    t.bigint "enfermeiro_id", null: false
    t.string "classificacao_risco_id"
    t.string "protocolo"
    t.datetime "data_triagem"
    t.text "pdf_data"
    t.string "pdf_file_name"
    t.string "pdf_content_type"
    t.integer "pdf_file_size"
    t.jsonb "dados", default: {}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "medico_id"
    t.index ["enfermeiro_id"], name: "index_relatorio_triagems_on_enfermeiro_id"
    t.index ["medico_id"], name: "index_relatorio_triagems_on_medico_id"
    t.index ["paciente_fake_id"], name: "index_relatorio_triagems_on_paciente_fake_id"
  end

  add_foreign_key "relatorio_triagems", "enfermeiros"
  add_foreign_key "relatorio_triagems", "medicos"
  add_foreign_key "relatorio_triagems", "paciente_fakes"
end
