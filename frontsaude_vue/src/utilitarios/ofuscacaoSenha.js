// ofuscacaoSenha.js
import { tabelaSaude } from "./tabelaSaude";

export function ofuscarSenha(senha) {
  console.log("🔐 Iniciando ofuscação da senha:", senha);

  // 1️⃣ Inversão
  const invertida = senha.split("").reverse().join("");
  console.log("1️⃣ Senha invertida:", invertida);

  // 2️⃣ XOR
  const chaveXOR = 42;
  const xorArray = [...invertida].map(c => c.charCodeAt(0) ^ chaveXOR);
  console.log("2️⃣ XOR aplicado:", xorArray);

  // 3️⃣ Deslocamento modular
  const deslocamento = 7;
  const deslocados = xorArray.map(n => (n + deslocamento) % tabelaSaude.length);
  console.log("3️⃣ Após deslocamento modular:", deslocados);

  // 4️⃣ Mapeamento na tabela da saúde
  const elementos = deslocados.map(n => tabelaSaude[n % tabelaSaude.length]);
  console.log("4️⃣ Mapeado na tabela da saúde:", elementos);

  // 5️⃣ Permutação de blocos (troca pares consecutivos)
  for (let i = 0; i < elementos.length - 1; i += 2) {
    [elementos[i], elementos[i + 1]] = [elementos[i + 1], elementos[i]];
  }
  console.log("5️⃣ Após permutação de blocos:", elementos);

  // 6️⃣ Padding seguro - agora com mais valores e minúsculo
  const padding = ["aa","bb","cc","dd","ee","ff","gg","hh","ii","jj"];
  let j = 0;
  for (let i = 0; i < elementos.length; i += 2) {
    elementos.splice(i, 0, padding[j % padding.length]);
    j++;
  }
  console.log("6️⃣ Após padding seguro:", elementos);

  // 7️⃣ Remover qualquer undefined e juntar em string final
  const senhaOfuscada = elementos.filter(Boolean).join("");
  console.log("7️⃣ Senha final ofuscada:", senhaOfuscada);

  return { senhaOfuscada };
}
