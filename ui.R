# install.packages(c("shiny", "shinydashboard", "ggplot2", "dplyr", "psych", "car", "DT", "knitr", "rmarkdown", "tseries", "lmtest"))

library(shiny)
library(shinydashboard)
library(ggplot2)
library(dplyr)
library(psych) # Untuk statistik deskriptif lanjutan
library(car)   # Untuk uji Levene
library(DT)    # Untuk tabel interaktif
library(knitr) # Untuk rendering laporan
library(rmarkdown) # Untuk rendering laporan
library(tseries) # Untuk uji Jarque-Bera (normalitas)
library(lmtest) # Untuk uji Durbin-Watson (autokorelasi)

# --- CSS Kustom dengan Tema Pink & Hijau Modern ---
custom_css <- "
  @import url('https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap');
  
  /* Warna Dasar dengan Palet Modern */
  :root {
    --primary-green: #10B981; /* Emerald-500 - Hijau modern yang vibrant */
    --secondary-green: #065F46; /* Emerald-900 - Hijau gelap untuk kontras */
    --light-green: #D1FAE5; /* Emerald-100 - Hijau sangat terang */
    --accent-green: #34D399; /* Emerald-400 - Hijau accent */
    
    --primary-pink: #EC4899; /* Pink-500 - Pink modern yang vibrant */
    --secondary-pink: #BE185D; /* Pink-700 - Pink gelap */
    --light-pink: #FCE7F3; /* Pink-100 - Pink sangat terang */
    --accent-pink: #F472B6; /* Pink-400 - Pink accent */
    
    --gradient-primary: linear-gradient(135deg, #10B981 0%, #EC4899 100%);
    --gradient-light: linear-gradient(135deg, #D1FAE5 0%, #FCE7F3 100%);
    --gradient-dark: linear-gradient(135deg, #065F46 0%, #BE185D 100%);
    
    --text-primary: #1F2937; /* Gray-800 */
    --text-secondary: #6B7280; /* Gray-500 */
    --text-light: #9CA3AF; /* Gray-400 */
    --white: #FFFFFF;
    --surface: #F9FAFB; /* Gray-50 */
    --border-light: #E5E7EB; /* Gray-200 */
    
    --shadow-sm: 0 1px 2px 0 rgba(0, 0, 0, 0.05);
    --shadow-md: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);
    --shadow-lg: 0 10px 15px -3px rgba(0, 0, 0, 0.1), 0 4px 6px -2px rgba(0, 0, 0, 0.05);
    --shadow-xl: 0 20px 25px -5px rgba(0, 0, 0, 0.1), 0 10px 10px -5px rgba(0, 0, 0, 0.04);
  }

  /* Body dan Layout Umum */
  body {
    font-family: 'Inter', system-ui, -apple-system, sans-serif;
    background: var(--surface);
    color: var(--text-primary);
  }

  /* Header Dashboard dengan Gradient Modern */
  .main-header .logo {
    font-family: 'Inter', sans-serif;
    font-weight: 700;
    font-size: 20px;
    color: var(--white);
    background: var(--gradient-primary);
    border: none;
    box-shadow: var(--shadow-md);
    transition: all 0.3s ease;
  }
  
  .main-header .navbar {
    background: var(--gradient-primary);
    border: none;
    box-shadow: var(--shadow-lg);
  }
  
  .main-header .navbar .sidebar-toggle {
    color: var(--white);
    border: none;
    transition: all 0.2s ease;
  }
  
  .main-header .navbar .sidebar-toggle:hover {
    background: rgba(255, 255, 255, 0.1);
    border-radius: 8px;
  }

  /* Sidebar Modern dengan Glass Effect */
  .main-sidebar {
    background: rgba(255, 255, 255, 0.95);
    backdrop-filter: blur(10px);
    border-right: 1px solid var(--border-light);
    box-shadow: var(--shadow-xl);
  }
  
  .sidebar-menu > li.header {
    background: var(--gradient-primary);
    color: var(--white);
    font-weight: 600;
    font-size: 14px;
    text-transform: uppercase;
    letter-spacing: 0.5px;
    padding: 15px 20px;
    margin: 0;
    border-radius: 0;
  }
  
  .sidebar-menu li a {
    font-size: 15px;
    font-weight: 500;
    color: var(--text-primary);
    border-left: 4px solid transparent;
    margin: 2px 8px;
    border-radius: 12px;
    transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
    padding: 12px 16px;
  }
  
  .sidebar-menu li a:hover {
    background: var(--gradient-light);
    color: var(--primary-green);
    border-left-color: var(--primary-pink);
    transform: translateX(4px);
    box-shadow: var(--shadow-md);
  }
  
  .sidebar-menu li.active > a {
    background: var(--gradient-light);
    color: var(--primary-green);
    border-left-color: var(--primary-pink);
    font-weight: 600;
    box-shadow: var(--shadow-md);
  }
  
  .sidebar-menu .treeview-menu > li > a {
    margin-left: 20px;
    font-size: 14px;
    opacity: 0.8;
  }

  /* Box Components dengan Design System Modern */
  .box {
    border-radius: 16px;
    border: 1px solid var(--border-light);
    box-shadow: var(--shadow-md);
    transition: all 0.3s ease;
    overflow: hidden;
    background: var(--white);
  }
  
  .box:hover {
    box-shadow: var(--shadow-lg);
    transform: translateY(-2px);
  }
  
  .box.box-solid.box-primary > .box-header {
    background: var(--gradient-primary) !important;
    color: var(--white);
    border: none !important;
    padding: 20px 24px;
  }
  
  .box.box-solid.box-primary {
    border: 1px solid var(--border-light);
  }
  
  .box-title {
    font-weight: 600;
    font-size: 18px;
    color: var(--white);
    letter-spacing: -0.025em;
  }
  
  .box-body {
    padding: 24px;
    background: var(--white);
  }

  /* Cards dan Content Areas */
  .content-wrapper {
    background: var(--surface);
    min-height: 100vh;
  }
  
  .content {
    padding: 20px;
  }

  /* Input dan Form Elements */
  .form-control {
    border: 2px solid var(--border-light);
    border-radius: 12px;
    padding: 12px 16px;
    font-size: 14px;
    transition: all 0.2s ease;
    background: var(--white);
  }
  
  .form-control:focus {
    border-color: var(--primary-green);
    box-shadow: 0 0 0 3px rgba(16, 185, 129, 0.1);
    outline: none;
  }
  
  .form-group label {
    font-weight: 500;
    color: var(--text-primary);
    margin-bottom: 8px;
    font-size: 14px;
  }

  /* Buttons dengan Gradient dan Hover Effects */
  .btn {
    font-weight: 500;
    border-radius: 12px;
    padding: 12px 24px;
    font-size: 14px;
    transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
    border: none;
    cursor: pointer;
    text-transform: none;
    letter-spacing: 0.025em;
  }
  
  .btn-primary {
    background: var(--gradient-primary);
    color: var(--white);
    box-shadow: var(--shadow-md);
  }
  
  .btn-primary:hover, .btn-primary:focus {
    background: linear-gradient(135deg, #059669 0%, #DB2777 100%);
    transform: translateY(-2px);
    box-shadow: var(--shadow-lg);
    color: var(--white);
  }
  
  .btn-success {
    background: linear-gradient(135deg, var(--primary-green) 0%, var(--accent-green) 100%);
    color: var(--white);
    box-shadow: var(--shadow-md);
  }
  
  .btn-info {
    background: linear-gradient(135deg, var(--primary-pink) 0%, var(--accent-pink) 100%);
    color: var(--white);
    box-shadow: var(--shadow-md);
  }
  
  .btn:disabled {
    opacity: 0.6;
    cursor: not-allowed;
    transform: none;
  }

  /* File Input Modern */
  .form-group.shiny-input-container.shiny-input-container-file {
    background: var(--light-green);
    border: 2px dashed var(--primary-green);
    border-radius: 16px;
    padding: 20px;
    text-align: center;
    transition: all 0.3s ease;
  }
  
  .form-group.shiny-input-container.shiny-input-container-file:hover {
    border-color: var(--primary-pink);
    background: var(--light-pink);
  }
  
  .form-group.shiny-input-container.shiny-input-container-file .btn {
    background: var(--gradient-primary);
    border: none;
    color: var(--white);
    font-weight: 500;
  }

  /* Output Areas */
  .shiny-text-output {
    background: var(--gradient-light);
    border: 1px solid var(--border-light);
    border-radius: 12px;
    padding: 20px;
    font-family: 'Inter', monospace;
    font-size: 14px;
    line-height: 1.6;
    color: var(--text-primary);
    white-space: pre-wrap;
    word-wrap: break-word;
    max-height: 300px;
    overflow-y: auto;
    box-shadow: var(--shadow-sm);
  }
  
  .shiny-text-output::-webkit-scrollbar {
    width: 6px;
  }
  
  .shiny-text-output::-webkit-scrollbar-track {
    background: var(--border-light);
    border-radius: 3px;
  }
  
  .shiny-text-output::-webkit-scrollbar-thumb {
    background: var(--primary-green);
    border-radius: 3px;
  }

  /* Typography Modern */
  h1, h2, h3, h4, h5, h6 {
    color: var(--text-primary);
    font-weight: 600;
    letter-spacing: -0.025em;
  }
  
  h4 {
    font-size: 16px;
    margin: 24px 0 12px 0;
    color: var(--secondary-green);
  }
  
  p {
    color: var(--text-secondary);
    line-height: 1.6;
    margin-bottom: 16px;
  }
  
  hr {
    border: none;
    height: 1px;
    background: var(--gradient-primary);
    margin: 24px 0;
    opacity: 0.3;
  }

  /* Table Styling */
  .dataTables_wrapper {
    border-radius: 12px;
    overflow: hidden;
    box-shadow: var(--shadow-md);
  }
  
  table.dataTable {
    border-collapse: separate;
    border-spacing: 0;
  }
  
  table.dataTable thead th {
    background: var(--gradient-primary);
    color: var(--white);
    font-weight: 600;
    padding: 16px;
    border: none;
  }
  
  table.dataTable tbody td {
    padding: 12px 16px;
    border-bottom: 1px solid var(--border-light);
  }
  
  table.dataTable tbody tr:hover {
    background: var(--light-green);
  }

  /* Tab Panels */
  .nav-tabs {
    border-bottom: 2px solid var(--border-light);
    margin-bottom: 20px;
  }
  
  .nav-tabs > li > a {
    border: none;
    border-radius: 12px 12px 0 0;
    font-weight: 500;
    color: var(--text-secondary);
    margin-right: 4px;
    transition: all 0.2s ease;
  }
  
  .nav-tabs > li.active > a,
  .nav-tabs > li.active > a:hover,
  .nav-tabs > li.active > a:focus {
    background: var(--gradient-primary);
    color: var(--white);
    border: none;
  }
  
  .nav-tabs > li > a:hover {
    background: var(--light-green);
    color: var(--primary-green);
    border: none;
  }

  /* Animations dan Transitions */
  @keyframes fadeInUp {
    from {
      opacity: 0;
      transform: translateY(20px);
    }
    to {
      opacity: 1;
      transform: translateY(0);
    }
  }
  
  .box {
    animation: fadeInUp 0.5s ease-out;
  }
  
  /* Responsive Design */
  @media (max-width: 768px) {
    .box-body {
      padding: 16px;
    }
    
    .content {
      padding: 12px;
    }
    
    .btn {
      padding: 10px 20px;
      font-size: 13px;
    }
  }

  /* Loading States */
  .shiny-output-error {
    background: linear-gradient(135deg, #FEE2E2 0%, #FECACA 100%);
    border: 1px solid #F87171;
    color: #DC2626;
    border-radius: 12px;
    padding: 16px;
    font-weight: 500;
  }
  
  /* Custom Scrollbar untuk seluruh aplikasi */
  ::-webkit-scrollbar {
    width: 8px;
    height: 8px;
  }
  
  ::-webkit-scrollbar-track {
    background: var(--surface);
  }
  
  ::-webkit-scrollbar-thumb {
    background: var(--gradient-primary);
    border-radius: 4px;
  }
  
  ::-webkit-scrollbar-thumb:hover {
    background: var(--gradient-dark);
  }
"

ui <- dashboardPage(
  dashboardHeader(title = "✨ LiteraNusa Analytics",
                  titleWidth = 280,
                  tags$li(class = "dropdown",
                          tags$style(HTML(custom_css)) # Memanggil CSS di sini
                  )),
  dashboardSidebar(
    width = 280, # Menyesuaikan lebar sidebar untuk mencegah pemotongan
    sidebarMenu(
      menuItem("🏠 Beranda", tabName = "beranda", icon = icon("home")),
      menuItem("🔧 Manajemen Data", tabName = "manajemen_data", icon = icon("database")),
      menuItem("📊 Eksplorasi Data", tabName = "eksplorasi", icon = icon("chart-line")),
      menuItem("🧪 Uji Asumsi", tabName = "uji_asumsi", icon = icon("flask")),
      menuItem("📈 Statistik Inferensial", icon = icon("calculator"),
               menuSubItem("🔍 Uji Beda Rata-rata", tabName = "uji_rata_rata"),
               menuSubItem("📊 Uji Proporsi & Varians", tabName = "uji_prop_var")),
      menuItem("⚖️ ANOVA", tabName = "anova", icon = icon("balance-scale")),
      menuItem("📉 Regresi Linear", tabName = "regresi", icon = icon("chart-area")),
      hr(), # Garis pemisah
      div(style = "margin: 20px 15px; padding: 20px; background: linear-gradient(135deg, #D1FAE5 0%, #FCE7F3 100%); border-radius: 12px; border: 2px dashed #10B981;",
          h4("📁 Upload Data", style = "margin: 0 0 15px 0; color: #065F46; text-align: center; font-size: 16px;"),
          fileInput("upload_file", NULL,
                    placeholder = "Pilih File CSV",
                    accept = c("text/csv",
                               "text/comma-separated-values,text/plain",
                               ".csv")),
          div(style = "text-align: center;",
              checkboxInput("header", "File memiliki header", TRUE))
      )
    )
  ),
  dashboardBody(
    tabItems(
      # --- Beranda ---
      tabItem(tabName = "beranda",
              fluidRow(
                box(title = "🎯 Selamat Datang di LiteraNusa Analytics", status = "primary", solidHeader = TRUE, width = 12,
                    div(style = "text-align: center; padding: 20px;",
                        h3("Platform Analisis Data Statistik Modern", style = "color: #065F46; margin-bottom: 20px;"),
                        p("Dashboard canggih untuk analisis data komprehensif dengan antarmuka yang intuitif dan visualisasi yang menarik", 
                          style = "font-size: 16px; color: #6B7280; margin-bottom: 30px;")
                    )
                )
              ),
              fluidRow(
                box(title = "📊 Fitur Utama", status = "primary", solidHeader = TRUE, width = 4,
                    div(style = "padding: 10px;",
                        tags$ul(
                          tags$li("📁 Manajemen Data Interaktif", style = "margin-bottom: 8px;"),
                          tags$li("📈 Eksplorasi Data Visual", style = "margin-bottom: 8px;"),
                          tags$li("🧪 Uji Asumsi Statistik", style = "margin-bottom: 8px;"),
                          tags$li("📉 Analisis Inferensial", style = "margin-bottom: 8px;"),
                          tags$li("🔗 Regresi Linear Berganda", style = "margin-bottom: 8px;")
                        )
                    )
                ),
                box(title = "🛠️ Teknologi", status = "primary", solidHeader = TRUE, width = 4,
                    div(style = "padding: 10px;",
                        p("🔧 Framework: R Shiny", style = "margin-bottom: 8px;"),
                        p("📦 Paket Statistik: psych, car, DT", style = "margin-bottom: 8px;"),
                        p("📊 Visualisasi: ggplot2", style = "margin-bottom: 8px;"),
                        p("🎨 UI: shinydashboard", style = "margin-bottom: 8px;"),
                        p("✨ Design: Modern CSS3", style = "margin-bottom: 8px;")
                    )
                ),
                box(title = "🚀 Panduan Cepat", status = "primary", solidHeader = TRUE, width = 4,
                    div(style = "padding: 10px;",
                        p("1️⃣ Upload data CSV Anda", style = "margin-bottom: 8px;"),
                        p("2️⃣ Eksplorasi data di tab Eksplorasi", style = "margin-bottom: 8px;"),
                        p("3️⃣ Jalankan uji asumsi", style = "margin-bottom: 8px;"),
                        p("4️⃣ Lakukan analisis statistik", style = "margin-bottom: 8px;"),
                        p("5️⃣ Download hasil analisis", style = "margin-bottom: 8px;")
                    )
                )
              ),
              fluidRow(
                box(title = "📋 Data Tersedia", status = "primary", solidHeader = TRUE, width = 6,
                    div(style = "padding: 15px;",
                        h4("Dataset Default:", style = "color: #EC4899; margin-bottom: 15px;"),
                        div(style = "background: linear-gradient(135deg, #D1FAE5 0%, #FCE7F3 100%); padding: 15px; border-radius: 12px; margin-bottom: 10px;",
                            strong("📊 sovi_data.csv"), br(),
                            span("Dataset utama untuk analisis statistik", style = "color: #6B7280; font-size: 14px;")
                        ),
                        div(style = "background: linear-gradient(135deg, #D1FAE5 0%, #FCE7F3 100%); padding: 15px; border-radius: 12px;",
                            strong("📏 distance.csv"), br(),
                            span("Dataset jarak untuk analisis spasial", style = "color: #6B7280; font-size: 14px;")
                        )
                    )
                ),
                box(title = "💡 Tips Penggunaan", status = "primary", solidHeader = TRUE, width = 6,
                    div(style = "padding: 15px;",
                        div(style = "background: linear-gradient(135deg, #FCE7F3 0%, #D1FAE5 100%); padding: 15px; border-radius: 12px; margin-bottom: 10px;",
                            strong("✅ Upload Data"), br(),
                            span("Gunakan file CSV dengan header untuk hasil optimal", style = "color: #6B7280; font-size: 14px;")
                        ),
                        div(style = "background: linear-gradient(135deg, #FCE7F3 0%, #D1FAE5 100%); padding: 15px; border-radius: 12px; margin-bottom: 10px;",
                            strong("📈 Visualisasi"), br(),
                            span("Pilih jenis grafik yang sesuai dengan tipe data", style = "color: #6B7280; font-size: 14px;")
                        ),
                        div(style = "background: linear-gradient(135deg, #FCE7F3 0%, #D1FAE5 100%); padding: 15px; border-radius: 12px;",
                            strong("📊 Interpretasi"), br(),
                            span("Perhatikan interpretasi otomatis untuk setiap analisis", style = "color: #6B7280; font-size: 14px;")
                        )
                    )
                )
              )
      ),
      
      # --- Manajemen Data ---
      tabItem(tabName = "manajemen_data",
              fluidRow(
                box(title = "Manajemen Data", status = "primary", solidHeader = TRUE, width = 12,
                    p("Di sini Anda dapat melakukan pra-pemrosesan data, seperti mengkategorikan variabel kontinu, menangani nilai hilang, dll."),
                    uiOutput("var_categorize_ui"), # UI untuk memilih variabel yang akan dikategorikan
                    actionButton("categorize_data", "Kategorikan Data"),
                    br(), br(),
                    h4("Preview Data setelah Manajemen:"),
                    DTOutput("managed_data_preview"),
                    h4("Interpretasi Manajemen Data:"),
                    verbatimTextOutput("interpretasi_manajemen")
                )
              )
      ),
      
      # --- Eksplorasi Data ---
      tabItem(tabName = "eksplorasi",
              fluidRow(
                box(title = "Statistik Deskriptif", status = "primary", solidHeader = TRUE, width = 6,
                    uiOutput("var_desc_stat_ui"),
                    actionButton("run_desc_stat", "Tampilkan Statistik"),
                    br(), br(),
                    verbatimTextOutput("deskriptif_output"),
                    h4("Interpretasi Statistik Deskriptif:"),
                    verbatimTextOutput("interpretasi_deskriptif"),
                    downloadButton("download_desc_stat", "Download Statistik")
                ),
                box(title = "Visualisasi Data", status = "primary", solidHeader = TRUE, width = 6,
                    selectInput("plot_type", "Pilih Jenis Grafik:",
                                choices = c("Histogram", "Boxplot", "Scatter Plot", "Bar Plot")),
                    uiOutput("plot_vars_ui"),
                    actionButton("generate_plot", "Buat Grafik"),
                    br(), br(),
                    plotOutput("data_plot"),
                    h4("Interpretasi Visualisasi:"),
                    verbatimTextOutput("interpretasi_visualisasi"),
                    downloadButton("download_plot", "Download Grafik")
                )
              )
      ),
      
      # --- Uji Asumsi ---
      tabItem(tabName = "uji_asumsi",
              fluidRow(
                box(title = "Uji Normalitas", status = "primary", solidHeader = TRUE, width = 6,
                    uiOutput("var_normalitas_ui"),
                    actionButton("run_normalitas", "Lakukan Uji Normalitas"),
                    br(), br(),
                    verbatimTextOutput("normalitas_output"),
                    h4("Interpretasi Uji Normalitas:"),
                    verbatimTextOutput("interpretasi_normalitas"),
                    downloadButton("download_normalitas", "Download Hasil Normalitas")
                ),
                box(title = "Uji Homogenitas", status = "primary", solidHeader = TRUE, width = 6,
                    uiOutput("var_homogenitas_ui"),
                    actionButton("run_homogenitas", "Lakukan Uji Homogenitas"),
                    br(), br(),
                    verbatimTextOutput("homogenitas_output"),
                    h4("Interpretasi Uji Homogenitas:"),
                    verbatimTextOutput("interpretasi_homogenitas"),
                    downloadButton("download_homogenitas", "Download Hasil Homogenitas")
                )
              )
      ),
      
      # --- Uji Beda Rata-rata ---
      tabItem(tabName = "uji_rata_rata",
              fluidRow(
                box(title = "Uji Beda Rata-rata 1 Kelompok", status = "primary", solidHeader = TRUE, width = 6,
                    uiOutput("var_t_test_1_ui"),
                    numericInput("mu_t_test_1", "Nilai Hipotesis (Mu):", value = 0),
                    actionButton("run_t_test_1", "Lakukan Uji", class = "btn-primary"),
                    br(), br(),
                    verbatimTextOutput("t_test_1_output"),
                    h4("Interpretasi Uji Beda Rata-rata 1 Kelompok:"),
                    verbatimTextOutput("interpretasi_t_test_1"),
                    downloadButton("download_t_test_1", "Download Hasil", class = "btn-info")
                ),
                box(title = "Uji Beda Rata-rata 2 Kelompok", status = "primary", solidHeader = TRUE, width = 6,
                    selectInput("t_test_2_type", "Tipe Uji:", choices = c("Independen", "Berpasangan")),
                    uiOutput("var_t_test_2_ui"),
                    checkboxInput("var_equal", "Asumsi Varians Sama (untuk Independen)", TRUE),
                    actionButton("run_t_test_2", "Lakukan Uji", class = "btn-primary"),
                    br(), br(),
                    verbatimTextOutput("t_test_2_output"),
                    h4("Interpretasi Uji Beda Rata-rata 2 Kelompok:"),
                    verbatimTextOutput("interpretasi_t_test_2"),
                    downloadButton("download_t_test_2", "Download Hasil", class = "btn-info")
                )
              )
      ),
      
      # --- Uji Proporsi & Varians ---
      tabItem(tabName = "uji_prop_var",
              fluidRow(
                box(title = "Uji Proporsi 1 Kelompok", status = "primary", solidHeader = TRUE, width = 6,
                    uiOutput("var_prop_test_1_ui"),
                    numericInput("p_prop_test_1", "Proporsi Hipotesis (p):", value = 0.5, min = 0, max = 1),
                    actionButton("run_prop_test_1", "Lakukan Uji", class = "btn-primary"),
                    br(), br(),
                    verbatimTextOutput("prop_test_1_output"),
                    h4("Interpretasi Uji Proporsi 1 Kelompok:"),
                    verbatimTextOutput("interpretasi_prop_test_1"),
                    downloadButton("download_prop_test_1", "Download Hasil", class = "btn-info")
                ),
                box(title = "Uji Proporsi 2 Kelompok", status = "primary", solidHeader = TRUE, width = 6,
                    uiOutput("var_prop_test_2_ui"),
                    actionButton("run_prop_test_2", "Lakukan Uji", class = "btn-primary"),
                    br(), br(),
                    verbatimTextOutput("prop_test_2_output"),
                    h4("Interpretasi Uji Proporsi 2 Kelompok:"),
                    verbatimTextOutput("interpretasi_prop_test_2"),
                    downloadButton("download_prop_test_2", "Download Hasil", class = "btn-info")
                )
              ),
              fluidRow(
                box(title = "Uji Varians 1 Kelompok (Chi-squared)", status = "primary", solidHeader = TRUE, width = 6,
                    uiOutput("var_var_test_1_ui"),
                    numericInput("sigma_var_test_1", "Varians Hipotesis (Sigma^2):", value = 1),
                    actionButton("run_var_test_1", "Lakukan Uji", class = "btn-primary"),
                    br(), br(),
                    verbatimTextOutput("var_test_1_output"),
                    h4("Interpretasi Uji Varians 1 Kelompok:"),
                    verbatimTextOutput("interpretasi_var_test_1"),
                    downloadButton("download_var_test_1", "Download Hasil", class = "btn-info")
                ),
                box(title = "Uji Varians 2 Kelompok (F-test)", status = "primary", solidHeader = TRUE, width = 6,
                    uiOutput("var_var_test_2_ui"),
                    actionButton("run_var_test_2", "Lakukan Uji", class = "btn-primary"),
                    br(), br(),
                    verbatimTextOutput("var_test_2_output"),
                    h4("Interpretasi Uji Varians 2 Kelompok:"),
                    verbatimTextOutput("interpretasi_var_test_2"),
                    downloadButton("download_var_test_2", "Download Hasil", class = "btn-info")
                )
              )
      ),
      
      # --- ANOVA ---
      tabItem(tabName = "anova",
              fluidRow(
                box(title = "ANOVA Satu Arah", status = "primary", solidHeader = TRUE, width = 6,
                    uiOutput("anova_1_way_ui"),
                    actionButton("run_anova_1_way", "Lakukan ANOVA Satu Arah", class = "btn-primary"),
                    br(), br(),
                    verbatimTextOutput("anova_1_way_output"),
                    h4("Interpretasi ANOVA Satu Arah:"),
                    verbatimTextOutput("interpretasi_anova_1_way"),
                    downloadButton("download_anova_1_way", "Download Hasil", class = "btn-info")
                ),
                box(title = "ANOVA Dua Arah", status = "primary", solidHeader = TRUE, width = 6,
                    uiOutput("anova_2_way_ui"),
                    actionButton("run_anova_2_way", "Lakukan ANOVA Dua Arah", class = "btn-primary"),
                    br(), br(),
                    verbatimTextOutput("anova_2_way_output"),
                    h4("Interpretasi ANOVA Dua Arah:"),
                    verbatimTextOutput("interpretasi_anova_2_way"),
                    downloadButton("download_anova_2_way", "Download Hasil", class = "btn-info")
                )
              )
      ),
      
      # --- Regresi Linear Berganda ---
      tabItem(tabName = "regresi",
              fluidRow(
                box(title = "Regresi Linear Berganda", status = "primary", solidHeader = TRUE, width = 12,
                    uiOutput("reg_vars_ui"),
                    actionButton("run_regresi", "Jalankan Regresi", class = "btn-primary"),
                    br(), br(),
                    verbatimTextOutput("regresi_output"),
                    h4("Uji Asumsi Regresi:"),
                    tabsetPanel(
                      tabPanel("Normalitas Residual",
                               plotOutput("reg_norm_plot"),
                               verbatimTextOutput("reg_norm_test_output"),
                               h4("Interpretasi Normalitas Residual:"),
                               verbatimTextOutput("interpretasi_reg_norm")),
                      tabPanel("Homoskedastisitas",
                               plotOutput("reg_homo_plot"),
                               verbatimTextOutput("reg_homo_test_output"),
                               h4("Interpretasi Homoskedastisitas:"),
                               verbatimTextOutput("interpretasi_reg_homo")),
                      tabPanel("Multikolinearitas (VIF)",
                               verbatimTextOutput("reg_vif_output"),
                               h4("Interpretasi Multikolinearitas:"),
                               verbatimTextOutput("interpretasi_reg_vif")),
                      tabPanel("Autokorelasi (Durbin-Watson)",
                               verbatimTextOutput("reg_dw_output"),
                               h4("Interpretasi Autokorelasi:"),
                               verbatimTextOutput("interpretasi_reg_dw"))
                    ),
                    h4("Interpretasi Model Regresi:"),
                    verbatimTextOutput("interpretasi_regresi"),
                    downloadButton("download_regresi", "Download Hasil Regresi", class = "btn-info")
                )
              )
      )
    )
  )
)

server <- function(input, output, session) {
  
  # --- Data Reaktif ---
  data_r <- reactiveVal(NULL) # Untuk menyimpan data yang aktif (awal atau upload)
  
  # Memuat data default saat aplikasi dimulai
  observeEvent(TRUE, {
    tryCatch({
      # Load default data
      # Pastikan 'sovi_data.csv' ada di direktori kerja aplikasi Shiny
      sovi_data <- read.csv("sovi_data.csv")
      data_r(sovi_data)
      showNotification("Data 'sovi_data.csv' dimuat sebagai default.", type = "message")
    }, error = function(e) {
      showNotification(paste("Error loading default data (sovi_data.csv):", e$message), type = "error")
      data_r(NULL) # Reset data jika ada error
    })
  }, once = TRUE) # Hanya dijalankan sekali saat inisialisasi
  
  # Observer untuk mengunggah data baru
  observeEvent(input$upload_file, {
    req(input$upload_file)
    tryCatch({
      df <- read.csv(input$upload_file$datapath, header = input$header)
      data_r(df)
      showNotification("Data berhasil diunggah!", type = "success")
    }, error = function(e) {
      showNotification(paste("Error membaca file:", e$message), type = "error")
      data_r(NULL) # Reset data jika ada error
    })
  })
  
  # --- UI Dinamis untuk Pemilihan Variabel ---
  # Ini akan diperbarui setiap kali data_r() berubah (data diunggah atau dimanipulasi)
  observe({
    req(data_r()) # Pastikan ada data sebelum membuat UI dinamis
    df <- data_r()
    cols <- names(df)
    numeric_cols <- cols[sapply(df, is.numeric)]
    non_numeric_cols <- cols[!sapply(df, is.numeric)]
    
    # Manajemen Data
    output$var_categorize_ui <- renderUI({
      selectInput("cat_var_name", "Pilih Variabel Kontinu untuk Dikategorikan:", choices = numeric_cols)
      # numericInput("cat_num_bins", "Jumlah Kategori (Bins):", value = 3, min = 2) # Ini sudah ada
    })
    
    # Eksplorasi Data
    output$var_desc_stat_ui <- renderUI({
      selectInput("desc_stat_var", "Pilih Variabel untuk Statistik Deskriptif:", choices = cols)
    })
    output$plot_vars_ui <- renderUI({
      plot_type <- input$plot_type
      if (plot_type == "Histogram" || plot_type == "Boxplot") {
        selectInput("plot_var_x", "Pilih Variabel (Numerik):", choices = numeric_cols)
      } else if (plot_type == "Scatter Plot") {
        tagList(
          selectInput("plot_var_x", "Variabel X (Numerik):", choices = numeric_cols),
          selectInput("plot_var_y", "Variabel Y (Numerik):", choices = numeric_cols)
        )
      } else if (plot_type == "Bar Plot") {
        selectInput("plot_var_x", "Pilih Variabel (Kategorik/Diskret):", choices = cols)
      }
    })
    
    # Uji Asumsi
    output$var_normalitas_ui <- renderUI({
      selectInput("norm_var", "Pilih Variabel untuk Uji Normalitas:", choices = numeric_cols)
    })
    output$var_homogenitas_ui <- renderUI({
      tagList(
        selectInput("homo_var_response", "Variabel Respon (Numerik):", choices = numeric_cols),
        selectInput("homo_var_group", "Variabel Grup (Faktor):", choices = non_numeric_cols)
      )
    })
    
    # Uji Beda Rata-rata
    output$var_t_test_1_ui <- renderUI({
      selectInput("t_test_1_var", "Pilih Variabel Numerik:", choices = numeric_cols)
    })
    output$var_t_test_2_ui <- renderUI({
      if (input$t_test_2_type == "Independen") {
        tagList(
          selectInput("t_test_2_var_response", "Variabel Respon (Numerik):", choices = numeric_cols),
          selectInput("t_test_2_var_group", "Variabel Grup (2 Kategori):", choices = non_numeric_cols)
        )
      } else { # Berpasangan
        tagList(
          selectInput("t_test_2_var1", "Variabel 1 (Numerik):", choices = numeric_cols),
          selectInput("t_test_2_var2", "Variabel 2 (Numerik):", choices = numeric_cols)
        )
      }
    })
    
    # Uji Proporsi & Varians
    output$var_prop_test_1_ui <- renderUI({
      # Pilihan untuk proporsi bisa numerik (0/1) atau kategorik
      selectInput("prop_test_1_var", "Pilih Variabel (Biner/Kategorik):", choices = cols)
    })
    output$var_prop_test_2_ui <- renderUI({
      tagList(
        selectInput("prop_test_2_var_cat", "Variabel Kategori (Respon):", choices = cols),
        selectInput("prop_test_2_var_group", "Variabel Grup:", choices = cols)
      )
    })
    output$var_var_test_1_ui <- renderUI({
      selectInput("var_test_1_var", "Pilih Variabel Numerik:", choices = numeric_cols)
    })
    output$var_var_test_2_ui <- renderUI({
      tagList(
        selectInput("var_test_2_var_response", "Variabel Respon (Numerik):", choices = numeric_cols),
        selectInput("var_test_2_var_group", "Variabel Grup (2 Kategori):", choices = non_numeric_cols)
      )
    })
    
    # ANOVA
    output$anova_1_way_ui <- renderUI({
      tagList(
        selectInput("anova_1_resp", "Variabel Respon (Numerik):", choices = numeric_cols),
        selectInput("anova_1_factor", "Variabel Faktor (Kategorik):", choices = non_numeric_cols)
      )
    })
    output$anova_2_way_ui <- renderUI({
      tagList(
        selectInput("anova_2_resp", "Variabel Respon (Numerik):", choices = numeric_cols),
        selectInput("anova_2_factor1", "Variabel Faktor 1 (Kategorik):", choices = non_numeric_cols),
        selectInput("anova_2_factor2", "Variabel Faktor 2 (Kategorik):", choices = non_numeric_cols)
      )
    })
    
    # Regresi
    output$reg_vars_ui <- renderUI({
      tagList(
        selectInput("reg_dependent", "Variabel Dependen:", choices = numeric_cols),
        selectizeInput("reg_independent", "Variabel Independen:", choices = numeric_cols, multiple = TRUE)
      )
    })
  })
  
  # --- Manajemen Data Server ---
  managed_data <- reactiveVal(NULL) # Data yang sudah dimanipulasi
  
  observeEvent(input$categorize_data, {
    req(data_r(), input$cat_var_name, input$cat_num_bins)
    df <- data_r()
    var_name <- input$cat_var_name
    num_bins <- input$cat_num_bins
    
    if (!is.numeric(df[[var_name]])) {
      showNotification("Variabel yang dipilih harus numerik untuk dikategorikan.", type = "warning")
      return()
    }
    if (num_bins < 2) {
      showNotification("Jumlah kategori minimal 2.", type = "warning")
      return()
    }
    
    # Menggunakan cut() untuk mengkategorikan
    df[[paste0(var_name, "_cat")]] <- cut(df[[var_name]], breaks = num_bins, include.lowest = TRUE, ordered_result = TRUE)
    managed_data(df) # Simpan data yang dimanipulasi di reactiveVal terpisah
    
    output$interpretasi_manajemen <- renderText({
      paste0("Variabel '", var_name, "' telah berhasil dikategorikan menjadi ", num_bins, " kelompok baru dengan nama '", var_name, "_cat'.\n\n",
             "Interpretasi: Proses ini mengubah variabel kontinu menjadi diskret atau ordinal, memungkinkan analisis berdasarkan kelompok daripada nilai individu. Ini berguna untuk visualisasi (misalnya, bar plot) atau untuk penggunaan dalam uji statistik yang memerlukan variabel kategorik (misalnya, ANOVA jika kategori ini dijadikan faktor).")
    })
  })
  
  # Pratinjau data: gunakan data_r() jika managed_data() belum ada, sebaliknya gunakan managed_data()
  output$managed_data_preview <- renderDT({
    display_data <- if (is.null(managed_data())) data_r() else managed_data()
    req(display_data)
    DT::datatable(display_data, options = list(pageLength = 10, scrollX = TRUE)) # Tambah scrollX
  })
  
  # --- Eksplorasi Data Server ---
  output$deskriptif_output <- renderPrint({
    req(data_r(), input$desc_stat_var)
    df <- data_r()
    var_name <- input$desc_stat_var
    if (!var_name %in% names(df)) return(cat("Variabel tidak ditemukan."))
    if (is.numeric(df[[var_name]])) {
      summary(df[[var_name]])
      # Atau bisa pakai describe() dari psych
      # describe(df[[var_name]])
    } else {
      table(df[[var_name]])
    }
  })
  
  output$interpretasi_deskriptif <- renderText({
    req(data_r(), input$desc_stat_var)
    df <- data_r()
    var_name <- input$desc_stat_var
    if (!var_name %in% names(df)) return("Pilih variabel untuk interpretasi.")
    if (is.numeric(df[[var_name]])) {
      s_val <- summary(df[[var_name]])
      paste0("Statistik deskriptif untuk variabel '", var_name, "' menunjukkan:\n",
             "- Nilai minimum: ", round(s_val[1], 2), "\n",
             "- Kuartil pertama (Q1): ", round(s_val[2], 2), "\n",
             "- Median: ", round(s_val[3], 2), "\n",
             "- Rata-rata: ", round(s_val[4], 2), "\n",
             "- Kuartil ketiga (Q3): ", round(s_val[5], 2), "\n",
             "- Nilai maksimum: ", round(s_val[6], 2), "\n\n",
             "Interpretasi: Nilai-nilai ini memberikan gambaran tentang sebaran, tendensi sentral, dan rentang data. Median lebih baik untuk data miring, sedangkan rata-rata untuk data simetris. Jarak antara Q1 dan Q3 (IQR) menunjukkan sebaran data di tengah.")
    } else {
      t_val <- table(df[[var_name]])
      paste0("Distribusi frekuensi untuk variabel '", var_name, "':\n",
             paste(names(t_val), t_val, sep = ": ", collapse = "\n"), "\n\n",
             "Interpretasi: Ini menunjukkan berapa kali setiap kategori muncul dalam dataset. Sangat berguna untuk memahami distribusi data kategorik.")
    }
  })
  
  output$download_desc_stat <- downloadHandler(
    filename = function() { paste("statistik_deskriptif_", Sys.Date(), ".txt", sep="") },
    content = function(file) {
      df <- data_r()
      var_name <- input$desc_stat_var
      if (is.numeric(df[[var_name]])) {
        writeLines(capture.output(summary(df[[var_name]])), file)
      } else {
        writeLines(capture.output(table(df[[var_name]])), file)
      }
    }
  )
  
  data_plot_obj <- reactiveVal(NULL)
  
  observeEvent(input$generate_plot, {
    req(data_r(), input$plot_type, input$plot_var_x)
    df <- data_r()
    plot_type <- input$plot_type
    var_x <- input$plot_var_x
    
    p <- NULL
    interpretasi <- ""
    
    if (plot_type == "Histogram") {
      if (!is.numeric(df[[var_x]])) {
        interpretasi <- "Variabel harus numerik untuk Histogram."
      } else {
        p <- ggplot(df, aes_string(x = var_x)) + geom_histogram(bins = 30, fill = "steelblue", color = "black") +
          labs(title = paste("Histogram", var_x), x = var_x, y = "Frekuensi") + theme_minimal()
        interpretasi <- paste0("Histogram menunjukkan distribusi frekuensi dari variabel '", var_x, "'. Tinggi bar menunjukkan frekuensi kemunculan nilai dalam rentang tertentu. Bentuk histogram memberikan petunjuk tentang normalitas dan skewness data.")
      }
    } else if (plot_type == "Boxplot") {
      if (!is.numeric(df[[var_x]])) {
        interpretasi <- "Variabel harus numerik untuk Boxplot."
      } else {
        p <- ggplot(df, aes_string(y = var_x)) + geom_boxplot(fill = "lightblue") +
          labs(title = paste("Boxplot", var_x), y = var_x) + theme_minimal()
        interpretasi <- paste0("Boxplot untuk variabel '", var_x, "' menunjukkan kuartil (Q1, Median, Q3), rentang interkuartil (IQR), dan potensi outlier. Kotak menunjukkan 50% data tengah, garis di tengah adalah median, dan 'kumis' menunjukkan rentang data di luar IQR.")
      }
    } else if (plot_type == "Scatter Plot") {
      req(input$plot_var_y)
      var_y <- input$plot_var_y
      if (!is.numeric(df[[var_x]]) || !is.numeric(df[[var_y]])) {
        interpretasi <- "Kedua variabel harus numerik untuk Scatter Plot."
      } else {
        p <- ggplot(df, aes_string(x = var_x, y = var_y)) + geom_point() + geom_smooth(method = "lm", se = FALSE, color = "red") +
          labs(title = paste("Scatter Plot", var_x, "vs", var_y), x = var_x, y = var_y) + theme_minimal()
        interpretasi <- paste0("Scatter plot antara '", var_x, "' dan '", var_y, "' menunjukkan hubungan antara kedua variabel. Jika titik-titik cenderung membentuk pola linear, ini menunjukkan korelasi. Garis merah adalah garis regresi yang mengestimasi hubungan linear.")
      }
    } else if (plot_type == "Bar Plot") {
      # Pastikan data faktorial untuk bar plot yang benar
      # if (!is.factor(df[[var_x]])) { # tidak perlu di shiny, ggplot akan handle
      #   df[[var_x]] <- as.factor(df[[var_x]])
      # }
      p <- ggplot(df, aes_string(x = var_x)) + geom_bar(fill = "lightgreen", color = "black") +
        labs(title = paste("Bar Plot", var_x), x = var_x, y = "Count") + theme_minimal()
      interpretasi <- paste0("Bar plot menunjukkan frekuensi atau jumlah observasi untuk setiap kategori dari variabel '", var_x, "'. Tinggi bar merepresentasikan jumlah kemunculan setiap kategori.")
    } else {
      interpretasi <- "Pilihan variabel atau jenis plot tidak sesuai. Pastikan variabel numerik untuk Histogram/Boxplot/Scatter Plot, dan variabel yang sesuai untuk Bar Plot."
    }
    
    output$data_plot <- renderPlot({
      if (!is.null(p)) {
        print(p)
        data_plot_obj(p) # Simpan objek plot untuk diunduh
      }
    })
    output$interpretasi_visualisasi <- renderText({
      interpretasi
    })
  })
  
  output$download_plot <- downloadHandler(
    filename = function() {
      paste("plot_", input$plot_type, "_", Sys.Date(), ".png", sep="")
    },
    content = function(file) {
      req(data_plot_obj())
      ggsave(file, plot = data_plot_obj(), device = "png", width = 8, height = 6)
    }
  )
  
  
  # --- Uji Asumsi Server ---
  norm_test_result <- reactiveVal(NULL)
  output$normalitas_output <- renderPrint({
    req(data_r(), input$norm_var)
    var_data <- data_r()[[input$norm_var]]
    if (!is.numeric(var_data)) {
      cat("Variabel harus numerik untuk uji normalitas.")
      return()
    }
    # Shapiro-Wilk Test (cocok untuk n < 5000)
    shapiro_res <- tryCatch(shapiro.test(var_data), error = function(e) {
      cat("Shapiro-Wilk Test Error:", e$message, "\n")
      NULL
    })
    # Jarque-Bera Test (cocok untuk n > 2000)
    jb_res <- tryCatch(jarque.bera.test(var_data), error = function(e) {
      cat("Jarque-Bera Test Error:", e$message, "\n")
      NULL
    })
    
    norm_test_result(list(shapiro = shapiro_res, jb = jb_res))
    if (!is.null(shapiro_res)) {
      cat("Shapiro-Wilk Test:\n")
      print(shapiro_res)
    }
    if (!is.null(jb_res)) {
      cat("\nJarque-Bera Test:\n")
      print(jb_res)
    }
    if (is.null(shapiro_res) && is.null(jb_res)) {
      cat("Tidak ada uji normalitas yang dapat dilakukan. Pastikan data memadai.")
    }
  })
  
  output$interpretasi_normalitas <- renderText({
    req(norm_test_result())
    res <- norm_test_result()
    interpretasi <- ""
    p_value_shapiro <- NULL
    p_value_jb <- NULL
    
    if (!is.null(res$shapiro)) {
      p_value_shapiro <- res$shapiro$p.value
      if (p_value_shapiro < 0.05) {
        interpretasi <- paste0(interpretasi, "Berdasarkan Uji Shapiro-Wilk (p-value = ", round(p_value_shapiro, 4), " < 0.05), data TIDAK berdistribusi normal.\n")
      } else {
        interpretasi <- paste0(interpretasi, "Berdasarkan Uji Shapiro-Wilk (p-value = ", round(p_value_shapiro, 4), " >= 0.05), data berdistribusi normal.\n")
      }
    }
    if (!is.null(res$jb)) {
      p_value_jb <- res$jb$p.value
      if (p_value_jb < 0.05) {
        interpretasi <- paste0(interpretasi, "\nBerdasarkan Uji Jarque-Bera (p-value = ", round(p_value_jb, 4), " < 0.05), data TIDAK berdistribusi normal.")
      } else {
        interpretasi <- paste0(interpretasi, "\nBerdasarkan Uji Jarque-Bera (p-value = ", round(p_value_jb, 4), " >= 0.05), data berdistribusi normal.")
      }
    }
    if (is.null(p_value_shapiro) && is.null(p_value_jb)) {
      interpretasi <- "Tidak ada hasil uji normalitas yang valid untuk diinterpretasikan."
    }
    paste0(interpretasi, "\n\nInterpretasi Umum: Jika p-value dari uji normalitas lebih kecil dari taraf signifikansi (misal 0.05), maka kita menolak hipotesis nol bahwa data berdistribusi normal. Sebaliknya, jika p-value lebih besar atau sama dengan taraf signifikansi, maka kita tidak memiliki cukup bukti untuk menolak hipotesis nol, sehingga data diasumsikan berdistribusi normal.")
  })
  
  output$download_normalitas <- downloadHandler(
    filename = function() { paste("uji_normalitas_", Sys.Date(), ".txt", sep="") },
    content = function(file) {
      if (!is.null(norm_test_result()$shapiro)) {
        cat("Shapiro-Wilk Test:\n", file = file)
        capture.output(norm_test_result()$shapiro, file = file, append = TRUE)
      }
      if (!is.null(norm_test_result()$jb)) {
        cat("\nJarque-Bera Test:\n", file = file, append = TRUE)
        capture.output(norm_test_result()$jb, file = file, append = TRUE)
      }
    }
  )
  
  homo_test_result <- reactiveVal(NULL)
  output$homogenitas_output <- renderPrint({
    req(data_r(), input$homo_var_response, input$homo_var_group)
    df <- data_r()
    response_var <- df[[input$homo_var_response]]
    group_var <- as.factor(df[[input$homo_var_group]]) # Pastikan faktor
    
    if (!is.numeric(response_var)) {
      cat("Variabel respon harus numerik.")
      return()
    }
    if (nlevels(group_var) < 2) {
      cat("Variabel grup harus memiliki setidaknya 2 kategori unik.")
      return()
    }
    
    levene_res <- tryCatch(car::leveneTest(response_var ~ group_var), error = function(e) {
      cat("Levene's Test Error:", e$message, "\n")
      NULL
    })
    homo_test_result(levene_res)
    print(levene_res)
  })
  
  output$interpretasi_homogenitas <- renderText({
    req(homo_test_result())
    res <- homo_test_result()
    if (is.null(res)) {
      return("Tidak ada hasil uji homogenitas yang valid untuk diinterpretasikan.")
    }
    p_value <- res$`Pr(>F)`[1] # Ambil p-value dari kolom Pr(>F) baris pertama
    
    if (p_value < 0.05) {
      interpretasi <- paste0("Berdasarkan Uji Levene (p-value = ", round(p_value, 4), " < 0.05), varians antar kelompok TIDAK homogen.")
    } else {
      interpretasi <- paste0("Berdasarkan Uji Levene (p-value = ", round(p_value, 4), " >= 0.05), varians antar kelompok homogen.")
    }
    paste0(interpretasi, "\n\nInterpretasi Umum: Jika p-value dari uji homogenitas lebih kecil dari taraf signifikansi (misal 0.05), maka kita menolak hipotesis nol bahwa varians homogen. Ini berarti ada perbedaan signifikan dalam variabilitas data antar kelompok. Homogenitas varians adalah asumsi penting untuk beberapa uji parametrik seperti ANOVA dan t-test independen.")
  })
  
  output$download_homogenitas <- downloadHandler(
    filename = function() { paste("uji_homogenitas_", Sys.Date(), ".txt", sep="") },
    content = function(file) {
      writeLines(capture.output(homo_test_result()), file)
    }
  )
  
  # --- Uji Beda Rata-rata Server ---
  t_test_1_result <- reactiveVal(NULL)
  output$t_test_1_output <- renderPrint({
    req(data_r(), input$t_test_1_var, input$mu_t_test_1)
    var_data <- data_r()[[input$t_test_1_var]]
    if (!is.numeric(var_data)) {
      cat("Variabel harus numerik.")
      return()
    }
    test_res <- t.test(var_data, mu = input$mu_t_test_1)
    t_test_1_result(test_res)
    print(test_res)
  })
  
  output$interpretasi_t_test_1 <- renderText({
    req(t_test_1_result())
    res <- t_test_1_result()
    p_value <- res$p.value
    mean_val <- res$estimate
    
    if (p_value < 0.05) {
      interpretasi <- paste0("Berdasarkan uji t satu kelompok (p-value = ", round(p_value, 4), " < 0.05), terdapat bukti signifikan untuk menyatakan bahwa rata-rata populasi (", round(mean_val, 2), ") berbeda secara signifikan dari nilai hipotesis (", input$mu_t_test_1, ").")
    } else {
      interpretasi <- paste0("Berdasarkan uji t satu kelompok (p-value = ", round(p_value, 4), " >= 0.05), tidak ada cukup bukti signifikan untuk menyatakan bahwa rata-rata populasi (", round(mean_val, 2), ") berbeda secara signifikan dari nilai hipotesis (", input$mu_t_test_1, ").")
    }
    paste0(interpretasi, "\n\nInterpretasi Umum: Uji t satu kelompok digunakan untuk membandingkan rata-rata sampel dengan rata-rata populasi yang diasumsikan. Jika p-value < 0.05, kita menolak hipotesis nol (rata-rata sampel sama dengan rata-rata populasi).")
  })
  
  output$download_t_test_1 <- downloadHandler(
    filename = function() { paste("uji_t_1_kelompok_", Sys.Date(), ".txt", sep="") },
    content = function(file) {
      writeLines(capture.output(t_test_1_result()), file)
    }
  )
  
  t_test_2_result <- reactiveVal(NULL)
  output$t_test_2_output <- renderPrint({
    req(data_r(), input$t_test_2_type)
    df <- data_r()
    test_res <- NULL
    
    if (input$t_test_2_type == "Independen") {
      req(input$t_test_2_var_response, input$t_test_2_var_group)
      response_var <- df[[input$t_test_2_var_response]]
      group_var <- as.factor(df[[input$t_test_2_var_group]])
      if (!is.numeric(response_var) || nlevels(group_var) != 2) {
        cat("Variabel respon harus numerik dan variabel grup harus memiliki tepat 2 kategori unik untuk uji independen.")
        return()
      }
      test_res <- t.test(response_var ~ group_var, var.equal = input$var_equal)
    } else { # Berpasangan
      req(input$t_test_2_var1, input$t_test_2_var2)
      var1_data <- df[[input$t_test_2_var1]]
      var2_data <- df[[input$t_test_2_var2]]
      if (!is.numeric(var1_data) || !is.numeric(var2_data) || length(var1_data) != length(var2_data)) {
        cat("Kedua variabel harus numerik dan memiliki panjang yang sama untuk uji berpasangan.")
        return()
      }
      test_res <- t.test(var1_data, var2_data, paired = TRUE)
    }
    t_test_2_result(test_res)
    print(test_res)
  })
  
  output$interpretasi_t_test_2 <- renderText({
    req(t_test_2_result())
    res <- t_test_2_result()
    p_value <- res$p.value
    type <- input$t_test_2_type
    var_equal_text <- ifelse(input$var_equal, "asumsi varians sama", "asumsi varians tidak sama (Welch)")
    
    if (p_value < 0.05) {
      interpretasi <- paste0("Berdasarkan uji t ", tolower(type), " (p-value = ", round(p_value, 4), " < 0.05), terdapat bukti signifikan untuk menyatakan bahwa rata-rata antara dua kelompok/kondisi berbeda.")
    } else {
      interpretasi <- paste0("Berdasarkan uji t ", tolower(type), " (p-value = ", round(p_value, 4), " >= 0.05), tidak ada cukup bukti signifikan untuk menyatakan bahwa rata-rata antara dua kelompok/kondisi berbeda.")
    }
    if (type == "Independen") {
      interpretasi <- paste0(interpretasi, "\nUji ini dilakukan dengan ", var_equal_text, ".")
    }
    paste0(interpretasi, "\n\nInterpretasi Umum: Uji t dua kelompok digunakan untuk membandingkan rata-rata dari dua kelompok. Untuk uji independen, ini membandingkan rata-rata dua kelompok yang tidak terkait. Untuk uji berpasangan, ini membandingkan rata-rata dua pengukuran pada subjek yang sama. Jika p-value < 0.05, kita menolak hipotesis nol (tidak ada perbedaan rata-rata).")
  })
  
  output$download_t_test_2 <- downloadHandler(
    filename = function() { paste("uji_t_2_kelompok_", Sys.Date(), ".txt", sep="") },
    content = function(file) {
      writeLines(capture.output(t_test_2_result()), file)
    }
  )
  
  
  # --- Uji Proporsi & Varians Server ---
  prop_test_1_result <- reactiveVal(NULL)
  output$prop_test_1_output <- renderPrint({
    req(data_r(), input$prop_test_1_var, input$p_prop_test_1)
    data_var <- data_r()[[input$prop_test_1_var]]
    
    # Menghapus NA dari variabel yang dipilih
    data_var_clean <- na.omit(data_var)
    
    if (length(data_var_clean) == 0) {
      cat("Variabel terpilih kosong setelah menghapus nilai hilang.")
      return(NULL)
    }
    
    x <- NULL # jumlah keberhasilan
    n <- length(data_var_clean) # total observasi
    
    if (is.numeric(data_var_clean) && all(data_var_clean %in% c(0, 1))) {
      x <- sum(data_var_clean == 1)
    } else if (is.factor(data_var_clean) || is.character(data_var_clean)) {
      # Konversi ke faktor untuk memastikan level
      data_var_clean <- as.factor(data_var_clean)
      
      if (nlevels(data_var_clean) < 2) {
        cat("Variabel kategorik harus memiliki setidaknya dua level unik untuk uji proporsi.")
        return(NULL)
      }
      # Ambil hitungan kategori pertama sebagai 'success'
      x <- sum(data_var_clean == levels(data_var_clean)[1])
    } else {
      cat("Variabel harus biner (0/1) atau kategorik.")
      return(NULL)
    }
    
    if (is.null(x)) {
      cat("Tidak dapat menghitung proporsi dari variabel yang dipilih.")
      return(NULL)
    }
    
    test_res <- prop.test(x, n, p = input$p_prop_test_1)
    prop_test_1_result(test_res)
    print(test_res)
  })
  
  output$interpretasi_prop_test_1 <- renderText({
    req(prop_test_1_result())
    res <- prop_test_1_result()
    p_value <- res$p.value
    sample_prop <- res$estimate
    
    if (p_value < 0.05) {
      interpretasi <- paste0("Berdasarkan uji proporsi satu kelompok (p-value = ", round(p_value, 4), " < 0.05), terdapat bukti signifikan untuk menyatakan bahwa proporsi populasi (", round(sample_prop, 2), ") berbeda secara signifikan dari proporsi hipotesis (", input$p_prop_test_1, ").")
    } else {
      interpretasi <- paste0("Berdasarkan uji proporsi satu kelompok (p-value = ", round(p_value, 4), " >= 0.05), tidak ada cukup bukti signifikan untuk menyatakan bahwa proporsi populasi (", round(sample_prop, 2), ") berbeda secara signifikan dari proporsi hipotesis (", input$p_prop_test_1, ").")
    }
    paste0(interpretasi, "\n\nInterpretasi Umum: Uji proporsi satu kelompok digunakan untuk menguji apakah proporsi suatu kategori dalam sampel berbeda secara signifikan dari proporsi yang diasumsikan dalam populasi. Jika p-value < 0.05, kita menolak hipotesis nol (proporsi sampel sama dengan proporsi populasi).")
  })
  
  output$download_prop_test_1 <- downloadHandler(
    filename = function() { paste("uji_proporsi_1_kelompok_", Sys.Date(), ".txt", sep="") },
    content = function(file) {
      writeLines(capture.output(prop_test_1_result()), file)
    }
  )
  
  prop_test_2_result <- reactiveVal(NULL)
  output$prop_test_2_output <- renderPrint({
    req(data_r(), input$prop_test_2_var_cat, input$prop_test_2_var_group)
    df <- data_r()
    var_cat <- df[[input$prop_test_2_var_cat]]
    var_group <- as.factor(df[[input$prop_test_2_var_group]])
    
    # Menghapus NA pada kedua variabel secara bersamaan
    combined_data <- data.frame(var_cat, var_group)
    combined_data <- na.omit(combined_data)
    var_cat_clean <- combined_data$var_cat
    var_group_clean <- combined_data$var_group
    
    if (length(var_group_clean) == 0 || nlevels(var_group_clean) != 2) {
      cat("Variabel grup harus memiliki tepat 2 kategori unik dan tidak kosong setelah NA dihapus.")
      return(NULL)
    }
    
    # Konversi var_cat ke faktor jika belum
    var_cat_clean <- as.factor(var_cat_clean)
    if (nlevels(var_cat_clean) < 2) {
      cat("Variabel kategori respon harus memiliki setidaknya dua level unik.")
      return(NULL)
    }
    
    # Buat tabel kontingensi
    contingency_table <- table(var_cat_clean, var_group_clean)
    
    # Ambil hitungan untuk kategori pertama dari var_cat sebagai 'success'
    x <- contingency_table[1, ]
    n <- colSums(contingency_table)
    
    test_res <- prop.test(x, n)
    prop_test_2_result(test_res)
    print(test_res)
  })
  
  output$interpretasi_prop_test_2 <- renderText({
    req(prop_test_2_result())
    res <- prop_test_2_result()
    p_value <- res$p.value
    
    if (p_value < 0.05) {
      interpretasi <- paste0("Berdasarkan uji proporsi dua kelompok (p-value = ", round(p_value, 4), " < 0.05), terdapat bukti signifikan untuk menyatakan bahwa proporsi antar dua kelompok berbeda.")
    } else {
      interpretasi <- paste0("Berdasarkan uji proporsi dua kelompok (p-value = ", round(p_value, 4), " >= 0.05), tidak ada cukup bukti signifikan untuk menyatakan bahwa proporsi antar dua kelompok berbeda.")
    }
    paste0(interpretasi, "\n\nInterpretasi Umum: Uji proporsi dua kelompok digunakan untuk membandingkan proporsi keberhasilan antara dua kelompok independen. Jika p-value < 0.05, kita menolak hipotesis nol (proporsi kedua kelompok sama).")
  })
  
  output$download_prop_test_2 <- downloadHandler(
    filename = function() { paste("uji_proporsi_2_kelompok_", Sys.Date(), ".txt", sep="") },
    content = function(file) {
      writeLines(capture.output(prop_test_2_result()), file)
    }
  )
  
  var_test_1_result <- reactiveVal(NULL)
  output$var_test_1_output <- renderPrint({
    req(data_r(), input$var_test_1_var, input$sigma_var_test_1)
    var_data <- data_r()[[input$var_test_1_var]]
    if (!is.numeric(var_data)) {
      cat("Variabel harus numerik.")
      return(NULL)
    }
    if (length(var_data) < 2) {
      cat("Diperlukan setidaknya 2 observasi untuk menghitung varians.")
      return(NULL)
    }
    
    # Uji varians 1 kelompok biasanya dilakukan dengan chi-squared test
    # Hipotesis nol: varians sampel = sigma_var_test_1
    chi_sq_stat <- (length(var_data) - 1) * var(var_data, na.rm = TRUE) / input$sigma_var_test_1
    p_value <- 1 - pchisq(chi_sq_stat, df = length(var_data) - 1)
    test_res <- list(statistic = chi_sq_stat, parameter = length(var_data) - 1, p.value = p_value,
                     method = "Chi-squared Test for One Sample Variance",
                     data.name = input$var_test_1_var,
                     null.value = c("variance" = input$sigma_var_test_1),
                     estimate = c("sample variance" = var(var_data, na.rm = TRUE)))
    class(test_res) <- "htest" # Agar bisa diprint seperti hasil uji lainnya
    var_test_1_result(test_res)
    print(test_res)
  })
  
  output$interpretasi_var_test_1 <- renderText({
    req(var_test_1_result())
    res <- var_test_1_result()
    p_value <- res$p.value
    sample_var <- res$estimate[1]
    hyp_var <- res$null.value[1]
    
    if (p_value < 0.05) {
      interpretasi <- paste0("Berdasarkan uji varians satu kelompok (Chi-squared, p-value = ", round(p_value, 4), " < 0.05), terdapat bukti signifikan untuk menyatakan bahwa varians populasi (", round(sample_var, 2), ") berbeda secara signifikan dari varians hipotesis (", hyp_var, ").")
    } else {
      interpretasi <- paste0("Berdasarkan uji varians satu kelompok (Chi-squared, p-value = ", round(p_value, 4), " >= 0.05), tidak ada cukup bukti signifikan untuk menyatakan bahwa varians populasi (", round(sample_var, 2), ") berbeda secara signifikan dari varians hipotesis (", hyp_var, ").")
    }
    paste0(interpretasi, "\n\nInterpretasi Umum: Uji varians satu kelompok (uji Chi-squared) digunakan untuk menguji apakah varians sampel berbeda secara signifikan dari varians populasi yang diasumsikan. Jika p-value < 0.05, kita menolak hipotesis nol (varians sampel sama dengan varians populasi).")
  })
  
  output$download_var_test_1 <- downloadHandler(
    filename = function() { paste("uji_varians_1_kelompok_", Sys.Date(), ".txt", sep="") },
    content = function(file) {
      writeLines(capture.output(var_test_1_result()), file)
    }
  )
  
  var_test_2_result <- reactiveVal(NULL)
  output$var_test_2_output <- renderPrint({
    req(data_r(), input$var_test_2_var_response, input$var_test_2_var_group)
    df <- data_r()
    response_var <- df[[input$var_test_2_var_response]]
    group_var <- as.factor(df[[input$var_test_2_var_group]])
    
    if (!is.numeric(response_var)) {
      cat("Variabel respon harus numerik.")
      return(NULL)
    }
    if (nlevels(group_var) != 2) {
      cat("Variabel grup harus memiliki tepat 2 kategori unik.")
      return(NULL)
    }
    
    # Uji varians 2 kelompok biasanya F-test
    test_res <- var.test(response_var ~ group_var)
    var_test_2_result(test_res)
    print(test_res)
  })
  
  output$interpretasi_var_test_2 <- renderText({
    req(var_test_2_result())
    res <- var_test_2_result()
    p_value <- res$p.value
    
    if (p_value < 0.05) {
      interpretasi <- paste0("Berdasarkan uji varians dua kelompok (F-test, p-value = ", round(p_value, 4), " < 0.05), terdapat bukti signifikan untuk menyatakan bahwa varians antar dua kelompok TIDAK homogen.")
    } else {
      interpretasi <- paste0("Berdasarkan uji varians dua kelompok (F-test, p-value = ", round(p_value, 4), " >= 0.05), varians antar dua kelompok homogen.")
    }
    paste0(interpretasi, "\n\nInterpretasi Umum: Uji varians dua kelompok (uji F) digunakan untuk membandingkan varians dari dua populasi. Jika p-value < 0.05, kita menolak hipotesis nol (varians kedua kelompok sama).")
  })
  
  output$download_var_test_2 <- downloadHandler(
    filename = function() { paste("uji_varians_2_kelompok_", Sys.Date(), ".txt", sep="") },
    content = function(file) {
      writeLines(capture.output(var_test_2_result()), file)
    }
  )
  
  
  # --- ANOVA Server ---
  anova_1_way_result <- reactiveVal(NULL)
  output$anova_1_way_output <- renderPrint({
    req(data_r(), input$anova_1_resp, input$anova_1_factor)
    df <- data_r()
    response_var <- df[[input$anova_1_resp]]
    factor_var <- as.factor(df[[input$anova_1_factor]])
    
    if (!is.numeric(response_var)) {
      cat("Variabel respon harus numerik.")
      return(NULL)
    }
    if (nlevels(factor_var) < 2) {
      cat("Variabel faktor harus memiliki setidaknya 2 kategori unik.")
      return(NULL)
    }
    formula_anova <- as.formula(paste(input$anova_1_resp, "~", input$anova_1_factor))
    aov_res <- aov(formula_anova, data = df)
    summary_aov <- summary(aov_res)
    anova_1_way_result(summary_aov)
    print(summary_aov)
  })
  
  output$interpretasi_anova_1_way <- renderText({
    req(anova_1_way_result())
    res <- anova_1_way_result()
    # Pastikan indeks benar jika ada banyak baris output summary.aov
    p_value <- res[[1]][["Pr(>F)"]][!is.na(res[[1]][["Pr(>F)"]])] # Ambil p-value dari baris faktor, abaikan NA (residual)
    p_value <- p_value[1] # Ambil yang pertama jika ada beberapa faktor
    
    if (is.null(p_value)) {
      return("Tidak ada p-value valid untuk diinterpretasikan.")
    }
    
    if (p_value < 0.05) {
      interpretasi <- paste0("Berdasarkan ANOVA satu arah (p-value = ", round(p_value, 4), " < 0.05), terdapat bukti signifikan untuk menyatakan bahwa setidaknya ada satu perbedaan rata-rata antara kelompok-kelompok dari variabel '", input$anova_1_factor, "' terhadap variabel respon '", input$anova_1_resp, "'. Ini menunjukkan bahwa variabel faktor memiliki efek yang signifikan terhadap variabel respon.")
    } else {
      interpretasi <- paste0("Berdasarkan ANOVA satu arah (p-value = ", round(p_value, 4), " >= 0.05), tidak ada cukup bukti signifikan untuk menyatakan adanya perbedaan rata-rata antara kelompok-kelompok dari variabel '", input$anova_1_factor, "' terhadap variabel respon '", input$anova_1_resp, "'. Ini menunjukkan bahwa variabel faktor tidak memiliki efek yang signifikan.")
    }
    paste0(interpretasi, "\n\nInterpretasi Umum: ANOVA satu arah digunakan untuk membandingkan rata-rata dari tiga atau lebih kelompok independen. Jika p-value < 0.05, ini menunjukkan ada perbedaan rata-rata yang signifikan antar kelompok, tetapi tidak menjelaskan kelompok mana yang berbeda. Uji post-hoc (misalnya Tukey HSD) mungkin diperlukan untuk identifikasi lebih lanjut.")
  })
  
  output$download_anova_1_way <- downloadHandler(
    filename = function() { paste("anova_1_arah_", Sys.Date(), ".txt", sep="") },
    content = function(file) {
      writeLines(capture.output(anova_1_way_result()), file)
    }
  )
  
  anova_2_way_result <- reactiveVal(NULL)
  output$anova_2_way_output <- renderPrint({
    req(data_r(), input$anova_2_resp, input$anova_2_factor1, input$anova_2_factor2)
    df <- data_r()
    response_var <- df[[input$anova_2_resp]]
    factor1_var <- as.factor(df[[input$anova_2_factor1]])
    factor2_var <- as.factor(df[[input$anova_2_factor2]])
    
    if (!is.numeric(response_var)) {
      cat("Variabel respon harus numerik.")
      return(NULL)
    }
    if (nlevels(factor1_var) < 2 || nlevels(factor2_var) < 2) {
      cat("Variabel faktor harus memiliki setidaknya 2 kategori unik.")
      return(NULL)
    }
    formula_anova <- as.formula(paste(input$anova_2_resp, "~", input$anova_2_factor1, "*", input$anova_2_factor2))
    aov_res <- aov(formula_anova, data = df)
    summary_aov <- summary(aov_res)
    anova_2_way_result(summary_aov)
    print(summary_aov)
  })
  
  output$interpretasi_anova_2_way <- renderText({
    req(anova_2_way_result())
    res <- anova_2_way_result()
    
    # Pastikan indeks aman, ambil dari nama baris jika perlu
    p_values <- res[[1]][["Pr(>F)"]]
    names(p_values) <- rownames(res[[1]])
    
    p_val_f1 <- p_values[input$anova_2_factor1]
    p_val_f2 <- p_values[input$anova_2_factor2]
    p_val_interaksi <- p_values[paste0(input$anova_2_factor1, ":", input$anova_2_factor2)]
    
    interpretasi <- ""
    interpretasi <- paste0(interpretasi, "Berdasarkan ANOVA dua arah:\n")
    
    if (!is.na(p_val_f1) && p_val_f1 < 0.05) {
      interpretasi <- paste0(interpretasi, "- Efek utama dari '", input$anova_2_factor1, "' adalah signifikan (p-value = ", round(p_val_f1, 4), ").\n")
    } else if (!is.na(p_val_f1)) {
      interpretasi <- paste0(interpretasi, "- Efek utama dari '", input$anova_2_factor1, "' tidak signifikan (p-value = ", round(p_val_f1, 4), ").\n")
    } else {
      interpretasi <- paste0(interpretasi, "- Efek utama dari '", input$anova_2_factor1, "' tidak dapat dihitung atau tidak relevan.\n")
    }
    
    if (!is.na(p_val_f2) && p_val_f2 < 0.05) {
      interpretasi <- paste0(interpretasi, "- Efek utama dari '", input$anova_2_factor2, "' adalah signifikan (p-value = ", round(p_val_f2, 4), ").\n")
    } else if (!is.na(p_val_f2)) {
      interpretasi <- paste0(interpretasi, "- Efek utama dari '", input$anova_2_factor2, "' tidak signifikan (p-value = ", round(p_val_f2, 4), ").\n")
    } else {
      interpretasi <- paste0(interpretasi, "- Efek utama dari '", input$anova_2_factor2, "' tidak dapat dihitung atau tidak relevan.\n")
    }
    
    if (!is.na(p_val_interaksi) && p_val_interaksi < 0.05) {
      interpretasi <- paste0(interpretasi, "- Terdapat interaksi signifikan antara '", input$anova_2_factor1, "' dan '", input$anova_2_factor2, "' (p-value = ", round(p_val_interaksi, 4), "). Ini berarti efek dari satu faktor tergantung pada level faktor lainnya.")
    } else if (!is.na(p_val_interaksi)) {
      interpretasi <- paste0(interpretasi, "- Tidak ada interaksi signifikan antara '", input$anova_2_factor1, "' dan '", input$anova_2_factor2, "' (p-value = ", round(p_val_interaksi, 4), "). Ini berarti efek dari satu faktor tidak tergantung pada level faktor lainnya.")
    } else {
      interpretasi <- paste0(interpretasi, "- Efek interaksi tidak dapat dihitung atau tidak relevan.\n")
    }
    
    paste0(interpretasi, "\n\nInterpretasi Umum: ANOVA dua arah digunakan untuk menguji efek dua variabel faktor dan interaksinya terhadap satu variabel respon numerik. Jika ada interaksi signifikan, interpretasi efek utama mungkin kurang relevan.")
  })
  
  output$download_anova_2_way <- downloadHandler(
    filename = function() { paste("anova_2_arah_", Sys.Date(), ".txt", sep="") },
    content = function(file) {
      writeLines(capture.output(anova_2_way_result()), file)
    }
  )
  
  # --- Regresi Linear Berganda Server ---
  reg_model_result <- reactiveVal(NULL)
  output$regresi_output <- renderPrint({
    req(data_r(), input$reg_dependent, input$reg_independent)
    df <- data_r()
    dependent_var <- input$reg_dependent
    independent_vars <- input$reg_independent
    
    if (length(independent_vars) == 0) {
      cat("Pilih setidaknya satu variabel independen.")
      return(NULL)
    }
    formula_reg <- as.formula(paste(dependent_var, "~", paste(independent_vars, collapse = " + ")))
    model <- tryCatch(lm(formula_reg, data = df), error = function(e) {
      cat("Error running regression model:", e$message, "\n")
      NULL
    })
    reg_model_result(model)
    if (!is.null(model)) {
      print(summary(model))
    }
  })
  
  # Uji Asumsi Regresi
  output$reg_norm_plot <- renderPlot({
    req(reg_model_result())
    plot(reg_model_result(), which = 2) # Q-Q plot for residuals
  })
  
  output$reg_norm_test_output <- renderPrint({
    req(reg_model_result())
    resid_val <- residuals(reg_model_result())
    shapiro_res <- tryCatch(shapiro.test(resid_val), error = function(e) NULL)
    jb_res <- tryCatch(jarque.bera.test(resid_val), error = function(e) NULL)
    
    if (!is.null(shapiro_res)) {
      cat("Shapiro-Wilk Test (Residuals):\n")
      print(shapiro_res)
    }
    if (!is.null(jb_res)) {
      cat("\nJarque-Bera Test (Residuals):\n")
      print(jb_res)
    }
    if (is.null(shapiro_res) && is.null(jb_res)) {
      cat("Tidak ada uji normalitas yang dapat dilakukan untuk residual. Pastikan data memadai.")
    }
  })
  
  output$interpretasi_reg_norm <- renderText({
    req(reg_model_result())
    resid_val <- residuals(reg_model_result())
    shapiro_res <- tryCatch(shapiro.test(resid_val), error = function(e) NULL)
    jb_res <- tryCatch(jarque.bera.test(resid_val), error = function(e) NULL)
    interpretasi <- ""
    
    p_value_shapiro <- if (!is.null(shapiro_res)) shapiro_res$p.value else NULL
    p_value_jb <- if (!is.null(jb_res)) jb_res$p.value else NULL
    
    if (!is.null(p_value_shapiro)) {
      interpretasi <- paste0(interpretasi, "Normalitas Residuals (Shapiro-Wilk p-value: ", round(p_value_shapiro, 4), ").\n")
    }
    if (!is.null(p_value_jb)) {
      interpretasi <- paste0(interpretasi, "Normalitas Residuals (Jarque-Bera p-value: ", round(p_value_jb, 4), ").\n")
    }
    
    normal_shapiro <- if (!is.null(p_value_shapiro)) p_value_shapiro >= 0.05 else TRUE
    normal_jb <- if (!is.null(p_value_jb)) p_value_jb >= 0.05 else TRUE
    
    if (normal_shapiro && normal_jb) { # Asumsi jika salah satu tidak ada, anggap normal dari yang ada
      interpretasi <- paste0(interpretasi, "Interpretasi: Residual berdistribusi normal, asumsi normalitas terpenuhi.")
    } else {
      interpretasi <- paste0(interpretasi, "Interpretasi: Residual TIDAK berdistribusi normal, yang mungkin mengindikasikan masalah dengan asumsi normalitas.")
    }
    interpretasi <- paste0(interpretasi, "\n\nPlot Q-Q Normal juga membantu memvisualisasikan apakah titik-titik mengikuti garis diagonal. Penyimpangan besar menunjukkan non-normalitas.")
    interpretasi
  })
  
  output$reg_homo_plot <- renderPlot({
    req(reg_model_result())
    plot(fitted(reg_model_result()), residuals(reg_model_result()),
         xlab = "Nilai Prediksi", ylab = "Residual",
         main = "Residual vs Fitted Values")
    abline(h = 0, col = "red", lty = 2)
  })
  
  output$reg_homo_test_output <- renderPrint({
    req(reg_model_result())
    bptest_res <- tryCatch(car::ncvTest(reg_model_result()), error = function(e) {
      cat("Breusch-Pagan Test Error:", e$message, "\n")
      NULL
    }) # Breusch-Pagan test
    print(bptest_res)
  })
  
  output$interpretasi_reg_homo <- renderText({
    req(reg_model_result())
    res <- tryCatch(car::ncvTest(reg_model_result()), error = function(e) NULL)
    if (is.null(res)) {
      return("Tidak dapat menjalankan uji homoskedastisitas. Mungkin ada masalah dengan model atau data.")
    }
    p_value <- res$p
    
    if (p_value < 0.05) {
      interpretasi <- paste0("Berdasarkan Uji Breusch-Pagan (p-value = ", round(p_value, 4), " < 0.05), terdapat bukti heteroskedastisitas (varians residual TIDAK homogen).")
    } else {
      interpretasi <- paste0("Berdasarkan Uji Breusch-Pagan (p-value = ", round(p_value, 4), " >= 0.05), varians residual homogen (homoskedastisitas terpenuhi).")
    }
    paste0(interpretasi, "\n\nInterpretasi Umum: Plot Residual vs Fitted Values yang membentuk 'corong' atau pola lain mengindikasikan heteroskedastisitas. Uji Breusch-Pagan menguji secara formal. Pelanggaran asumsi ini dapat menyebabkan estimasi standar error yang bias.")
  })
  
  
  output$reg_vif_output <- renderPrint({
    req(reg_model_result())
    vif_values <- tryCatch(car::vif(reg_model_result()), error = function(e) {
      cat("VIF calculation error:", e$message, "\n")
      NULL
    })
    print(vif_values)
  })
  
  output$interpretasi_reg_vif <- renderText({
    req(reg_model_result())
    vif_values <- tryCatch(car::vif(reg_model_result()), error = function(e) NULL)
    if (is.null(vif_values)) {
      "Tidak dapat menghitung VIF. Pastikan ada lebih dari satu variabel prediktor dan tidak ada masalah multikolinearitas sempurna."
    } else {
      max_vif <- max(vif_values)
      if (max_vif > 5) { # Aturan umum, bisa juga > 10
        interpretasi <- paste0("Nilai VIF tertinggi adalah ", round(max_vif, 2), ". Terdapat indikasi multikolinearitas (jika VIF > 5 atau > 10).")
      } else {
        interpretasi <- paste0("Nilai VIF tertinggi adalah ", round(max_vif, 2), ". Tidak ada indikasi multikolinearitas signifikan.")
      }
      paste0(interpretasi, "\n\nInterpretasi Umum: Multikolinearitas terjadi ketika variabel independen saling berkorelasi tinggi. Nilai VIF (Variance Inflation Factor) yang tinggi (umumnya > 5 atau > 10) menunjukkan adanya multikolinearitas. Ini dapat mempengaruhi stabilitas estimasi koefisien regresi.")
    }
  })
  
  output$reg_dw_output <- renderPrint({
    req(reg_model_result())
    dw_test_res <- tryCatch(lmtest::dwtest(reg_model_result()), error = function(e) {
      cat("Durbin-Watson Test Error:", e$message, "\n")
      NULL
    })
    print(dw_test_res)
  })
  
  output$interpretasi_reg_dw <- renderText({
    req(reg_model_result())
    res <- tryCatch(lmtest::dwtest(reg_model_result()), error = function(e) NULL)
    if (is.null(res)) {
      return("Tidak dapat menjalankan uji Durbin-Watson. Mungkin ada masalah dengan model atau data.")
    }
    p_value <- res$p.value
    dw_stat <- res$statistic
    
    interpretasi <- paste0("Statistik Durbin-Watson: ", round(dw_stat, 2), " (p-value = ", round(p_value, 4), ").\n")
    
    # Interpretasi Durbin-Watson lebih kompleks, p-value lebih langsung
    # Nilai DW mendekati 2 menunjukkan tidak ada autokorelasi.
    # Nilai < 2 menunjukkan autokorelasi positif, dan nilai > 2 menunjukkan autokorelasi negatif.
    # Jika p-value < 0.05, biasanya ada autokorelasi.
    if (p_value < 0.05) {
      interpretasi <- paste0(interpretasi, "Terdapat indikasi autokorelasi pada residual (p-value < 0.05).")
    } else {
      interpretasi <- paste0(interpretasi, "Tidak ada indikasi autokorelasi pada residual (p-value >= 0.05). Asumsi autokorelasi terpenuhi.")
    }
    paste0(interpretasi, "\n\nInterpretasi Umum: Uji Durbin-Watson menguji keberadaan autokorelasi pada residual. Autokorelasi terjadi ketika residual tidak independen satu sama lain. Pelanggaran asumsi ini dapat menyebabkan estimasi standar error yang tidak akurat.")
  })
  
  
  output$interpretasi_regresi <- renderText({
    req(reg_model_result())
    model_summary <- summary(reg_model_result())
    r_squared <- model_summary$r.squared
    adj_r_squared <- model_summary$adj.r.squared
    f_statistic_p <- if (!is.null(model_summary$fstatistic)) model_summary$fstatistic[3] else NA
    
    interpretasi <- paste0("Model Regresi:\n",
                           "Variabel dependen: ", input$reg_dependent, "\n",
                           "Variabel independen: ", paste(input$reg_independent, collapse = ", "), "\n\n",
                           "R-squared: ", round(r_squared, 4), " (Adjusted R-squared: ", round(adj_r_squared, 4), ").\n",
                           "Interpretasi: R-squared menunjukkan proporsi variasi dalam variabel dependen yang dapat dijelaskan oleh variabel independen dalam model. Adjusted R-squared lebih baik untuk membandingkan model dengan jumlah prediktor berbeda.\n\n")
    
    if (!is.na(f_statistic_p)) {
      interpretasi <- paste0(interpretasi, "Uji F Global (p-value): ", round(f_statistic_p, 4), ".\n",
                             "Interpretasi: Jika p-value Uji F < 0.05, ini menunjukkan bahwa setidaknya satu dari variabel independen secara signifikan memprediksi variabel dependen. Model secara keseluruhan adalah signifikan.\n\n")
    } else {
      interpretasi <- paste0(interpretasi, "Uji F Global tidak tersedia atau tidak relevan untuk model ini.\n\n")
    }
    
    interpretasi <- paste0(interpretasi, "Koefisien Regresi:\n")
    
    coef_table <- as.data.frame(model_summary$coefficients)
    for (i in 1:nrow(coef_table)) {
      coef_name <- rownames(coef_table)[i]
      estimate <- coef_table[i, "Estimate"]
      p_value <- coef_table[i, "Pr(>|t|)"]
      interpretasi <- paste0(interpretasi, "- ", coef_name, ": Estimasi = ", round(estimate, 4), ", p-value = ", round(p_value, 4), ". ")
      if (p_value < 0.05) {
        interpretasi <- paste0(interpretasi, "Signifikan.\n")
      } else {
        interpretasi <- paste0(interpretasi, "Tidak signifikan.\n")
      }
    }
    interpretasi <- paste0(interpretasi, "\nInterpretasi Umum Koefisien: Estimasi koefisien menunjukkan perubahan rata-rata pada variabel dependen untuk setiap peningkatan satu unit pada variabel independen yang bersangkutan, dengan variabel lain konstan. P-value untuk setiap koefisien menunjukkan signifikansi individual variabel independen.")
    interpretasi
  })
  
  output$download_regresi <- downloadHandler(
    filename = function() { paste("hasil_regresi_", Sys.Date(), ".txt", sep="") },
    content = function(file) {
      writeLines(capture.output(summary(reg_model_result())), file)
    }
  )
  
}

shinyApp(ui, server)