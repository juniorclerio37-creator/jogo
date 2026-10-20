# Integração publicitária preparada, ainda não ativada

O APK não contém SDK publicitário, não solicita acesso à internet para anúncios e não exibe anúncios simulados. Os botões correspondentes estão desabilitados. As funcionalidades principais são offline e a economia não depende de anúncios.

`scripts/ads.gd` fornece uma ponte opcional para a API GDScript do plugin gratuito Poing Studios, com detecção do singleton Android e concessão da recompensa somente no callback de recompensa. Faz cleanup após dispensa/falha e impede duplicação do callback. A indisponibilidade do provedor é testada; o carregamento e exibição nativos não foram testados. `enabled` permanece false.

Referência da API consultada via Git: https://github.com/poingstudios/godot-admob-plugin, commit `1b37d46ae6c362b8310d7a2f9756dd9e5a56063d`. Não foi copiado ou distribuído o plugin no projeto; ele possui licença MIT própria.

IDs oficiais de demonstração Android:
- App: `ca-app-pub-3940256099942544~3347511713`
- Rewarded: `ca-app-pub-3940256099942544/5224354917`

Para continuar: escolher uma versão do plugin compatível com Godot 4.6.3, instalar os scripts e AAR correspondentes, configurar exportação Gradle/manifesto, inicializar Google Mobile Ads após consentimento UMP aplicável e testar em aparelho. Adicionar `INTERNET` somente nessa compilação e confirmar política de privacidade, dados coletados pelo SDK e público-alvo. Os caminhos do adaptador devem ser confrontados com a versão do plugin instalada.

Vincular os callbacks a ações explícitas: +3 giros, +150 moedas ou baú (+200 moedas/+1 cristal). Não chamar a concessão ao abrir o vídeo, ao fechar ou em falhas. Limitar frequência, oferecer saída e manter a exploração gratuita. Construções são instantâneas, portanto não existe anúncio de aceleração nesta versão.

Não substituir IDs por unidades reais, criar conta AdMob ou publicar sem autorização do proprietário. Nenhuma conta ou chave é necessária para desenvolver e testar a versão offline atual.
