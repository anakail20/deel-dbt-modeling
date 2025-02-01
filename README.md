# Deel DBT Modeling

## 📌 Overview
This project models **Globepay payment transaction data** using `dbt` (Data Build Tool).  
It is structured using **dbt best practices**, following a **layered transformation approach** with **staging, intermediate, and marts** layers.

---

## ** 1. Preliminary Data Exploration**
The dataset includes **Globepay payment transactions**, capturing:
- **Accepted transactions** (`stg_globepay_acceptances.sql`).
- **Chargeback transactions** (`stg_globepay_chargebacks.sql`).

From the raw data, we identified:
- **Transaction-level details**, such as `external_ref`, `state`, `amount`, `currency`, and `country`.
- **Chargeback tracking**, with `chargeback_flag` showing whether a chargeback has occurred.

### **Key Observations**
✅ **Multiple currencies** → Transactions occur in different currencies and require currency formatting.  
✅ **Missing chargeback data** → Some transactions are missing chargeback information, requiring careful handling.  
✅ **CVV usage tracking** → Some transactions include whether the CVV was provided (`cvv_used`).  
✅ **Exchange rates available** → Certain transactions have exchange rates, which can be useful for normalization.  

---

## ** Summary of Model Architecture**
This project is structured into **three layers**, following dbt best practices:

### **1️.Staging Layer (`stg_`)**
- **Raw data cleanup and formatting.**
- Extracts data from **Globepay API sources**.
- Ensures consistency in data types and field naming.

#### **Staging Models**
- `stg_globepay_acceptances.sql` → Cleans and processes acceptance transactions.
- `stg_globepay_chargebacks.sql` → Cleans chargeback transaction data.

---

### **2️. Intermediate Layer (`int_`)**
- **Joins and enriches staging models**.
- Adds business logic such as chargeback details.

#### **Intermediate Models**
- `int_globepay_transactions.sql` → Combines acceptance and chargeback data.

---

### **3️. Marts Layer (`mart_`)**
- **Finalized tables for analytics and reporting.**
- Aggregates data for insights.

#### **Marts Models**
- `payment_transactions.sql` → Provides a **complete view of payment transactions**, including chargebacks.
- `transaction_metrics_by_country.sql` → Aggregates **acceptance rates and chargebacks per country**.

---

## ** Lineage Graphs**
This dbt project follows a **clear lineage** where marts models depend only on staging or intermediate layers.

### **Lineage Flow**
```plaintext
stg_globepay_acceptances      stg_globepay_chargebacks
        |                              |
        |                              |
        v                              v
  int_globepay_transactions  <-- Joins both sources
        |
        v
 payment_transactions  <-- Uses only intermediate
        |
        v
transaction_metrics_by_country  <-- Aggregated analytics per country
