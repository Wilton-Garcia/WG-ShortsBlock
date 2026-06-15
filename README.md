# WG-ShortsBlock

WG-ShortsBlock é uma extensão para Safari no macOS que remove/bloqueia os YouTube Shorts, deixando a navegação mais limpa e focada em vídeos tradicionais.

## Funcionalidades

* Remove a seção de Shorts da página inicial do YouTube.
* Oculta Shorts nos resultados de pesquisa.
* Bloqueia links e elementos relacionados aos Shorts.
* Funciona diretamente no Safari para macOS.

## Download

Baixe a versão mais recente:

**WG-ShortsBlock 1.0**

https://github.com/Wilton-Garcia/WG-ShortsBlock/blob/main/WG-ShortsBlcok%201.0/WG-ShortsBlock.app/Contents/MacOS/WG-ShortsBlock

## Instalação

1. Baixe o aplicativo.

2. Mova o aplicativo para a pasta `Applications`.

3. Execute o aplicativo pelo menos uma vez.

4. Abra o Safari.

5. Vá em:

   `Safari > Settings > Extensions`

6. Localize **WG-ShortsBlock** na lista.

7. Marque a extensão para ativá-la.

8. Conceda as permissões solicitadas para o YouTube.

Após a ativação, recarregue as páginas do YouTube.

## Desenvolvimento

### Requisitos

* macOS
* Xcode
* Safari

### Compilando o projeto

1. Clone o repositório:

```bash
git clone https://github.com/Wilton-Garcia/WG-ShortsBlock.git
```

2. Abra o projeto no Xcode.

3. Selecione o target principal do aplicativo.

4. Execute:

```bash
Product > Run
```

ou utilize o atalho:

```text
⌘ + R
```

5. O Xcode irá compilar o aplicativo e incorporar automaticamente a extensão Safari.

6. Após a execução, habilite a extensão em:

```text
Safari > Settings > Extensions
```

### Executando extensões não assinadas

Caso esteja utilizando uma conta gratuita da Apple ou compilando localmente sem assinatura de desenvolvedor:

1. Abra o Safari.
2. Vá em:

```text
Safari > Settings > Advanced
```

3. Habilite:

```text
Show Develop menu in menu bar
```

4. No menu superior escolha:

```text
Develop > Allow Unsigned Extensions
```

5. Confirme a operação.

Observação: o Safari pode exigir que essa opção seja habilitada novamente após ser fechado.

## Como funciona

A extensão monitora a interface do YouTube e remove elementos relacionados aos Shorts, evitando distrações e melhorando a experiência de navegação.

## Licença

Este projeto é distribuído sob a licença MIT.

## Autor

Wilton Garcia
