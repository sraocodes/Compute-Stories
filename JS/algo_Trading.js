%%{init: {
    'theme': 'default',
    'themeVariables': {
        'background': '#ffffff',
        'primaryTextColor': '#000000',
        'fontFamily': 'Segoe UI, Tahoma, Geneva, Verdana, sans-serif',
        'fontSize': '16px',
        'nodePadding': '12px',
        'rankSpacing': 50,
        'nodeSpacing': 50,
        'edgeLabelBackground':'#ffffff',
        'fontWeight': 'bold'
    }
}}%%
flowchart TB
    %% Define styles for subgraphs with enhanced text styles
    classDef marketData fill:#FFD700,stroke:#333,stroke-width:2px, color:#1a1a1a, fontWeight:bold, fontSize:18px
    classDef signalGen fill:#87CEFA,stroke:#333,stroke-width:2px, color:#1a1a1a, fontWeight:bold, fontSize:18px
    classDef trendAnalysis fill:#90EE90,stroke:#333,stroke-width:2px, color:#1a1a1a, fontWeight:bold, fontSize:18px
    classDef tradeExec fill:#FFB6C1,stroke:#333,stroke-width:2px, color:#1a1a1a, fontWeight:bold, fontSize:18px
    classDef nodeStyle fill:#ffffff,stroke:#333,stroke-width:1px, color:#333333, fontSize:16px

    %% Subgraph 1: Market Data Processing
    subgraph "Market Data Processing"
        A1["Raw Market Data Collection"]
        A2["Data Cleaning & Normalization"]
        A3["Time Series Alignment"]
        A1 --> A2 --> A3
    end
    class A1,A2,A3 marketData

    %% Subgraph 2: Signal Generation
    subgraph "Signal Generation"
        B1["Statistical Arbitrage"]
        B2["Market Microstructure"]
        B3["Order Book Analysis"]
        B4["Fourier/Spectral Analysis"]
    end
    class B1,B2,B3,B4 signalGen

    %% Subgraph 3: Market Trend Analysis
    subgraph "Market Trend Analysis"
        C1["Time Series Analysis"]
        C2["Pattern Recognition"]
        C3["Volatility Modeling"]
    end
    class C1,C2,C3 trendAnalysis

    %% Subgraph 4: Trade Execution
    subgraph "Trade Execution"
        D1["Order Splitting"]
        D2["Smart Order Routing"]
        D3["Latency Optimization"]
    end
    class D1,D2,D3 tradeExec

    %% Define connections between subgraphs
    A3 --> B1
    A3 --> B2
    A3 --> B3
    A3 --> B4

    B1 --> C1
    B2 --> C2
    B3 --> C3
    B4 --> C3

    C1 --> D1
    C2 --> D1
    C3 --> D1

    D1 --> D2
    D2 --> D3
