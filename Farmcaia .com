<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Farmácia Hospital Sandy Shores</title>
    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            background-color: #e8f5e9;
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            align-items: flex-start;
            height: 100vh;
        }

        .container {
            background-color: #fff;
            margin-top: 30px;
            padding: 30px;
            border-radius: 20px;
            box-shadow: 0 4px 10px rgba(0,0,0,0.2);
            width: 500px;
        }

        h1 {
            text-align: center;
            color: #2e7d32;
            margin-bottom: 20px;
        }

        .produto {
            background-color: #f9f9f9;
            padding: 15px;
            border-radius: 10px;
            margin-bottom: 15px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .produto-info {
            flex: 1;
        }

        .produto-info strong {
            display: block;
            color: #2e7d32;
            margin-bottom: 5px;
        }

        .controls {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        input[type="number"] {
            width: 60px;
            padding: 5px;
            border-radius: 8px;
            border: 1px solid #ccc;
            text-align: center;
        }

        button {
            background-color: #2e7d32;
            color: white;
            border: none;
            padding: 6px 12px;
            border-radius: 8px;
            cursor: pointer;
            transition: background-color 0.3s;
        }

        button:hover {
            background-color: #1b5e20;
        }

        .desconto {
            margin-top: 15px;
            padding: 10px;
            background-color: #e8f5e9;
            border-radius: 10px;
        }

        .desconto label {
            color: #2e7d32;
            font-weight: bold;
        }

        .gabarito {
            margin-top: 20px;
            background-color: #f1f8f1;
            padding: 15px;
            border-radius: 10px;
            max-height: 200px;
            overflow-y: auto;
        }

        .gabarito h3 {
            margin-top: 0;
            color: #2e7d32;
            text-align: center;
        }

        .gabarito ul {
            list-style: none;
            padding: 0;
            margin: 0;
        }

        .gabarito li {
            margin-bottom: 5px;
            color: #333;
        }

        .total {
            margin-top: 20px;
            font-size: 1.7em;
            text-align: center;
            color: #2e7d32;
            font-weight: bold;
        }

        .botoes {
            margin-top: 20px;
            text-align: center;
            display: flex;
            justify-content: center;
            gap: 15px;
        }

    </style>
</head>
<body>
    <div class="container">
        <h1>Farmácia Hospital Sandy Shores</h1>

        <div class="produto">
            <div class="produto-info">
                <strong>Kit Médico</strong>R$2500
            </div>
            <div class="controls">
                <input type="number" id="qtd_kit" value="1" min="1">
                <button onclick="adicionar('Kit Médico', 2500, 'qtd_kit')">Adicionar</button>
            </div>
        </div>

        <div class="produto">
            <div class="produto-info">
                <strong>Bandagem</strong>R$1500
            </div>
            <div class="controls">
                <input type="number" id="qtd_bandagem" value="1" min="1">
                <button onclick="adicionar('Bandagem', 1500, 'qtd_bandagem')">Adicionar</button>
            </div>
        </div>

        <div class="produto">
            <div class="produto-info">
                <strong>Gazes</strong>R$1500
            </div>
            <div class="controls">
                <input type="number" id="qtd_gazes" value="1" min="1">
                <button onclick="adicionar('Gazes', 1500, 'qtd_gazes')">Adicionar</button>
            </div>
        </div>

        <div class="produto">
            <div class="produto-info">
                <strong>Adrenalina</strong>R$8000
            </div>
            <div class="controls">
                <input type="number" id="qtd_adrenalina" value="1" min="1">
                <button onclick="adicionar('Adrenalina', 8000, 'qtd_adrenalina')">Adicionar</button>
            </div>
        </div>

        <div class="produto">
            <div class="produto-info">
                <strong>Analgésicos</strong>R$800
            </div>
            <div class="controls">
                <input type="number" id="qtd_analgesicos" value="1" min="1">
                <button onclick="adicionar('Analgésicos', 800, 'qtd_analgesicos')">Adicionar</button>
            </div>
        </div>

        <div class="desconto">
            <label>
                <input type="checkbox" id="usarDesconto" onclick="atualizarTotal()"> Aplicar Desconto de 20%
            </label>
        </div>

        <div class="gabarito">
            <h3>Itens Adicionados</h3>
            <ul id="listaItens"></ul>
        </div>

        <div class="total">
            Total: <span id="total">R$ 0,00</span>
        </div>

        <div class="botoes">
            <button onclick="limpar()">Limpar</button>
            <button onclick="gerarNotaFiscal()">Gerar Nota Fiscal</button>
        </div>
    </div>

    <script>
        let subtotal = 0;
        let itens = [];

        function adicionar(nome, valorUnitario, idQuantidade) {
            const quantidade = parseInt(document.getElementById(idQuantidade).value) || 0;
            const valorTotalProduto = valorUnitario * quantidade;
            subtotal += valorTotalProduto;

            const itemExistente = itens.find(item => item.nome === nome);

            if (itemExistente) {
                itemExistente.quantidade += quantidade;
            } else {
                itens.push({ nome, quantidade });
            }

            atualizarLista();
            atualizarTotal();
        }

        function atualizarLista() {
            const lista = document.getElementById('listaItens');
            lista.innerHTML = '';

            itens.forEach(item => {
                const li = document.createElement('li');
                li.innerText = `${item.nome} x${item.quantidade}`;
                lista.appendChild(li);
            });
        }

        function formatarMoeda(valor) {
            return valor.toLocaleString('pt-BR', { style: 'currency', currency: 'BRL' });
        }

        function atualizarTotal() {
            const usarDesconto = document.getElementById('usarDesconto').checked;
            let totalFinal = subtotal;

            if (usarDesconto) {
                const desconto = subtotal * 0.20;
                totalFinal = subtotal - desconto;
            }

            totalFinal = Math.max(totalFinal, 0);
            document.getElementById('total').innerText = formatarMoeda(totalFinal);
        }

        function limpar() {
            subtotal = 0;
            itens = [];
            atualizarLista();
            atualizarTotal();

            const inputs = document.querySelectorAll('input[type="number"]');
            inputs.forEach(input => input.value = 1);

            document.getElementById('usarDesconto').checked = false;
        }

        function gerarNotaFiscal() {
            if (itens.length === 0) {
                alert("Nenhum item adicionado!");
                return;
            }

            const usarDesconto = document.getElementById('usarDesconto').checked;
            let nota = "----- NOTA FISCAL -----\n\n";

            itens.forEach(item => {
                nota += `${item.nome} - Quantidade: ${item.quantidade}\n`;
            });

            nota += "\nSubtotal: " + formatarMoeda(subtotal);

            if (usarDesconto) {
                const desconto = subtotal * 0.20;
                nota += "\nDesconto (20%): -" + formatarMoeda(desconto);
                nota += "\nTotal: " + formatarMoeda(subtotal - desconto);
            } else {
                nota += "\nTotal: " + formatarMoeda(subtotal);
            }

            nota += "\n\n------------------------";

            alert(nota);
        }
    </script>
</body>
</html>
