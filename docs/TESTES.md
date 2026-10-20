# Evidências de validação — versão 0.1

Ambiente: Linux x86_64; Godot 4.6.3 oficial; OpenJDK 21; Android SDK 36 / build-tools 36.0.0.

## Executado

- `tools/check.sh`: importação dos recursos e **51 verificações, 0 falhas**, incluindo teste estatístico com 10.000 giros e semente fixa.
- Jornada completa sem anúncios/pagamentos: 236 explorações gratuitas e as 21 etapas de construção, partindo de 350 moedas. Verificado progresso 100%, data do selo e bloqueio de obras repetidas.
- Probabilidades somando 100%; frequência observada de cada resultado dentro de 2 pontos percentuais do peso configurado.
- Saldo insuficiente, bairros inválidos, giro sem recursos, missão prematura e recompensa repetida rejeitados.
- Save/load preservando saldo e progresso; recuperação após corrupção do arquivo principal usando backup.
- Oito telas instanciadas na cena real; animação de roleta concluindo uma única transação; animação do carimbo executada.
- Ausência de provedor publicitário tratada sem conceder recompensa ou interromper o jogo.
- Exportação Android debug assinada; `apksigner verify --verbose` confirmou assinaturas v2 e v3. Pacote `org.brasilquest.passaporte`, versão 0.1.0, mínimo API 24, target/compile API 36.
- Exportação Linux e inicialização do binário empacotado em modo headless, sem erro de execução.
- Inicialização pelas instruções salvas: `tools/start.sh --headless --quit-after 60`.

## Correções realizadas

A leitura JSON retornava números float nas listas; normalizar os níveis para inteiros corrigiu a verificação de persistência. Também foi corrigida a configuração de importação ETC2/ASTC exigida pelo exportador Android e o caminho de cache gravável do sdkmanager.

## Limites da evidência

Os testes funcionais e de interface usam Godot headless: não substituem revisão visual, testes de toque e desempenho em aparelho físico. Não foi instalado/executado o APK em celular ou emulador. Não foram testados anúncios nativos ou consentimento UMP. Não foi realizada consulta geográfica validada, pois o proxy bloqueou as fontes tentadas. Queimados/Japeri são preparação de expansão, sem mapas jogáveis.

O `aapt2 dump badging` consegue ler o manifesto, mas informa uma referência de ícone temático não utilizada no template Android. A assinatura passa; é necessário conferir o ícone no launcher de um aparelho. O editor pode emitir aviso de ausência de daemon/dispositivo ADB; isso não impede exportação ou execução offline.

Logs brutos da validação são entregues em `build/validation.log` e `build/package-smoke.log`. Os hashes dos artefatos estão em `build/SHA256SUMS`.
