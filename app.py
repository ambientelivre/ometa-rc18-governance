import logging
from typing import Dict, Any
from metadata.ingestion.ometa.ometa_api import OpenMetadata

logger = logging.getLogger("HelloWorldKPIApp")

class HelloWorldApp:
    def __init__(self, metadata: OpenMetadata, config: Dict[str, Any]):
        self.metadata = metadata
        self.config = config
        self.message = config.get("message", "Hello World do OpenMetadata!")

    def run(self) -> None:
        logger.info("==================================================")
        logger.info(f" [APP HELLO WORLD] -> {self.message}")
        
        # Teste de comunicação simples com o servidor OpenMetadata
        try:
            version = self.metadata.get_server_version()
            logger.info(f" Conexão estabelecida com sucesso! Versão do OM: {version}")
        except Exception as e:
            logger.error(f" Falha ao consultar versão do OpenMetadata: {e}")
            
        logger.info("==================================================")

    def trigger_ui_view() -> str:
        """
        Estrutura em Markdown/HTML simples que pode ser injetada em um Dashboard 
        ou Custom Property para exibição visual direta na interface gráfica.
        """
        return f"""
# 🚀 {self.message}

---

### 📊 Painel de KPI - Visão Inicial
* Status da Aplicação: **Ativa / Audit-Ready**
* Módulo: **BACEN RC 18 Governance**
* Próximo Passo: Integrar leituras do Profiler e do Grafo de Linhagem.

---
*Gerado por HelloWorldKPIApp*
"""
