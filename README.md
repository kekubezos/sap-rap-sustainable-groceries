# SAP RAP: Sustainable Groceries Management Application

An end-to-end cloud enterprise application developed on the **SAP BTP ABAP Environment** using the **ABAP RESTful Application Programming Model (RAP)** and consumed via **SAP Fiori Elements (OData V4)**.

---

## 📸 App Preview & Demonstration

<!-- If you recorded a GIF, put it here: ![App Demo](docs/demo.gif) -->

![App Overview](docs/screenshot-initial.png)
_Figure 1: Sustainable Groceries List Report preview with custom action button._

![Action Execution](docs/screenshot-expired.png)
_Figure 2: Automatic status transition to 'Expired = Yes' upon executing the action._

---

## 🏗️ Technical Architecture & Key Components

1. **Data Layer (Core Data Services):**
   - **Root View Entity (`ZR_11GROCERIES`):** Defines the underlying persistence model with administrative fields and semantic data typing.
   - **Projection View (`ZC_11GROCERIES`):** Consumption layer exposing domain attributes and UI annotations for the Fiori Elements template.

2. **Business Logic & Behavior Model:**
   - **Root Behavior Definition (`ZR_11GROCERIES`):** Managed implementation with draft support (`with draft;`), standard CRUD operations, and the custom instance action `checkExpirationDate`.
   - **Projection Behavior Definition (`ZC_11GROCERIES`):** Exposes transactional behavior and actions (`use action checkExpirationDate;`) to the OData protocol layer.
   - **Behavior Pool (`ZBP_R_11GROCERIES`):** Contains the ABAP Cloud business logic using Entity Manipulation Language (EML). Validates items against `cl_abap_context_info=>get_system_date()`, persists changes using transactional keys (`%tky`), and propagates updated entity buffers back to the UI.

3. **Service Exposure:**
   - **Service Definition (`ZUI_Z11GROCERIES_O4`):** Binds the projection entity for external consumption.
   - **Service Binding:** Published as an OData V4 UI service endpoint.

---

## 📂 Repository Structure

- `src/cds/` – CDS Data Definitions and Projection Behavior Definition.
- `src/behavior/` – Root Behavior Definition and local ABAP Behavior Pool implementation.
- `src/service/` – OData V4 Service Definition.
- `docs/` – Screenshots and demo assets.

---

## 🛠️ Tech Stack & Tools

- **ABAP Cloud / SAP RAP** (Managed Scenario with Draft)
- **EML (Entity Manipulation Language)**
- **OData V4 Protocol**
- **SAP Fiori Elements**
- **ABAP Development Tools (ADT) in Eclipse**
