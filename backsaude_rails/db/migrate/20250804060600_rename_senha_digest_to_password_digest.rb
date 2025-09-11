class RenameSenhaDigestToPasswordDigest < ActiveRecord::Migration[8.0]
  def change
    rename_column :enfermeiros, :senha_digest, :password_digest
  end
end
