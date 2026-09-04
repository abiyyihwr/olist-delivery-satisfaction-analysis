# olist-delivery-satisfaction-analysis

Analisis end-to-end untuk mengidentifikasi wilayah prioritas audit SLA logistik 
berdasarkan tingkat keterlambatan pengiriman dan dampaknya terhadap kepuasan 
pelanggan, menggunakan dataset publik Olist E-Commerce (Brazil).

## 🔗 Portofolio Lengkap
Dokumentasi CRISP-DM lengkap (Business Understanding, Data Prep, Analysis, 
Insight & Recommendation): [Link Notion](https://app.notion.com/p/Delivery-Driven-Customer-Satisfaction-Analysis-Olist-E-Commerce-d09804e95aaf828aa96c018a1591f1ef?source=copy_link)

## 📊 Dashboard
Dashboard Power BI 3 halaman: [Link Google Drive](https://drive.google.com/file/d/1zjAsI0eMRc-LLR4J3QOU-kYIQm1bAgHR/view?usp=sharing)

## 🎯 Business Question
Wilayah mana yang perlu diprioritaskan untuk audit dan renegosiasi SLA dengan 
mitra logistik, berdasarkan tingkat keterlambatan dan dampaknya ke kepuasan 
pelanggan?

## 🛠️ Tools
- Python (pandas) — data preparation & analysis
- SQL — eksplorasi awal data
- Power BI — dashboard & visualisasi
- Notion — dokumentasi

## 📁 Struktur Repository
- `notebooks/` — notebook analisis utama (Python)
- `sql/` — query eksplorasi data
- `output/` — data mart hasil olahan (CSV)

## 📌 Dataset
[Olist Brazilian E-Commerce Public Dataset](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce) 
(Kaggle)

## 🔑 Key Findings
- Rio de Janeiro teridentifikasi sebagai satu-satunya wilayah High Priority
- 53,48% pesanan terlambat berujung skor ulasan rendah (vs 8,87% pesanan tepat waktu)
- RJ menyumbang ~40% dari seluruh kasus keterlambatan ekstrem di ekosistem Olist