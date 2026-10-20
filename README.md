# Brasil Quest — Passaporte das Cidades

Versão 0.1 em Godot 4.6.3 / GDScript. Vertical offline de Nova Iguaçu, com código e arte originais. Nenhum serviço pago, publicação ou anúncio real foi ativado.

## Jogar

Android ARM64 (incluindo Motorola Edge 60 Fusion): [baixe o APK menor, cerca de 27 MB](https://raw.githubusercontent.com/juniorclerio37-creator/jogo/refs/heads/downloads/build/brasil-quest-arm64.apk). O preset `Android arm64` gera essa versão com o mesmo jogo e apenas as bibliotecas do processador ARM64.

Android universal: instale `build/brasil-quest-debug.apk` em um dispositivo Android 7.0/API 24 ou superior. Autorize a instalação por esse gerenciador de arquivos quando o Android solicitar. É um APK de desenvolvimento assinado com chave de debug, sem publicação na Play Store. ARMv7, ARM64 e x86_64 incluídos. Instalação em aparelho físico ainda não testada.

No computador: abra `project.godot` no Godot 4.6.3 e pressione F6/F5, ou execute `godot --path .`. Há também uma exportação Linux em `build/`; mantenha o executável e o `.pck` juntos.

1. Entre em Cidade. Toque em um dos sete bairros no mapa.
2. Explore trilhas para obter 35 moedas e 1 giro gratuitamente. Pode repetir, com intervalo de 1 segundo. Não usa relógio do aparelho nem conexão.
3. Gire a roleta e aplique moedas para desbloquear, construir e melhorar cada bairro.
4. Resgate as quatro missões; troque cristais por moedas na loja.
5. Conclua as 21 etapas para carimbar o passaporte e liberar Queimados na coleção. Queimados e Japeri ainda não possuem mapas jogáveis.

Não há ataques, apostas, saques, compras reais ou obrigação de assistir anúncios. As obras são instantâneas: aceleração de construção não é necessária nesta versão.

## Conteúdo implementado

- Início, mapa esquemático do Brasil, mapa interativo de Nova Iguaçu, roleta animada, missões, passaporte, loja virtual e configurações.
- Centro, Bairro da Luz, Posse, Comendador Soares, Cabuçu, Tinguá e Serra do Vulcão: três estágios cada.
- Casas vetoriais em perspectiva isométrica, vegetação animada, vias ilustradas e cadeados. O desenho é gerado por `scripts/map.gd`; os SVGs estão em `assets/`.
- Monumento fictício Farol da Mata, exibido no passaporte e no mapa ao completar a cidade; selo original Guardião da Serra com animação de carimbo.
- Seis resultados de roleta com probabilidades públicas em `data/world.json`. Total de 100%; resultado persistido antes da animação para evitar prêmio duplicado ao fechar o jogo.
- Salvamento local versionado, escrita por arquivo temporário e cópia de recuperação. Sem servidor ou conta.
- Catálogo das 13 cidades na ordem solicitada, com sementes de expansão em `data/expansion.json`.

## Desenvolvimento e testes

Neste ambiente, use o checkout existente `/workspace/jogo`; as tarefas já são isoladas. Não crie worktree para desenvolver.

```sh
cd /workspace/jogo
./tools/check.sh          # importa recursos e executa testes com save isolado
./tools/build.sh          # testes + APK debug assinado + exportação Linux
```

As ferramentas Android e os templates ficam em `/workspace/tooling`, fora do código-fonte. O script configura `HOME=/workspace/tooling/godot-home` para usar as preferências do editor e os templates existentes; o Java é OpenJDK 21. Android SDK: platform-tools, plataformas 35/36 e build-tools 35.0.1/36.0.0. A instalação foi realizada pelo sdkmanager oficial com verificação normal; o arquivo de templates Godot foi verificado pelo SHA-512 oficial.

Em outra máquina: instale Godot 4.6.3 e seus export templates, JDK 17 ou 21, Android SDK platform-tools, plataforma 36 e build-tools 36.0.0. Em Editor Settings → Export → Android, configure os caminhos de Java e SDK. Use os presets incluídos em `export_presets.cfg`. Os scripts `tools/` usam caminhos deste ambiente; adapte-os ou execute os comandos Godot diretamente. Não use a chave de debug para publicar.

Testes: `godot --headless --path . --script tests/run.gd`. Use um HOME temporário para não alterar seu progresso. O teste realmente constrói as 21 etapas, testa moedas insuficientes, limites, missões sem duplicação, probabilidades em 10.000 giros determinísticos, save/backup, todas as telas, animação de giro e carimbo. Relatórios em `docs/TESTES.md`.

## Arquitetura e expansão

- `state.gd`: economia, sorteio, progressão e persistência, separado da interface.
- `main.gd`: navegação e ações; `map.gd`, `atlas.gd`, `wheel.gd`: desenho vetorial.
- `data/world.json`: conteúdo da cidade e recompensas; `expansion.json`: fila de expansão.
- `ads.gd`: ponte opcional para Poing/Google AdMob, desativada e sem dependência obrigatória.

Antes de adicionar a segunda cidade, separar o estado por ID de cidade e migrar o save v1. O arquivo de expansão é uma preparação editorial, não uma implementação de múltiplos mapas.

## Limitações e próximos passos

Esta é uma primeira vertical funcional, não a edição final pronta para loja. Faltam revisão geográfica com fontes acessíveis, refinamento visual, marcos reais específicos, áudio, testes em telas/aparelhos Android e integração nativa dos anúncios. Os prédios são representações genéricas, não reproduções de monumentos reais. Leia `docs/GEOGRAFIA.md` e `docs/ADMOB.md`.

Não foi incluído um fluxo de reset destrutivo. Para um save novo no desenvolvimento, use outro HOME ou outro diretório de dados Godot. O progresso de teste não é o progresso do aplicativo instalado no celular.
