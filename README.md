# prompt-vault

Prompt Vault is a Flutter application designed to serve as a high-quality repository for AI prompts. It helps users move beyond simple queries by using a structured "Wizard" to engineer complex, effective prompts and storing them securely in a "Vault."

### **Core Features**

*   **The Prompt Wizard:**
    *   A guided, multi-step interface that breaks down prompt creation into four key components: **Goal**, **Context**, **Success Criteria**, and **Response Format**.
    *   This structured approach ensures the resulting prompt is well-defined and ready for any LLM (like GPT-4 or Gemini).
*   **AI-Powered Refinement:**
    *   Uses an `AIService` to process the raw inputs from the Wizard into a polished, professional prompt.
*   **The Vault (Management System):**
    *   **Firestore Integration:** All prompts are stored in a Firebase collection named `vault`, ensuring they are synced across devices.
    *   **Categorization:** Prompts are automatically tagged by type (e.g., *Professional*, *Step-by-Step*, *Questions*) with unique color-coding for easy visual scanning.
    *   **Quick Actions:** Users can search, edit, delete, or copy prompts directly to their clipboard for immediate use.
*   **Modern Design System:**
    *   **Dynamic Theming:** Supports both Light and Dark modes, with a custom color palette (vibrant purples and teals).
    *   **Optimized Readability:** Uses a unique "Global Zoom" (1.5x) transformation in the main app builder to ensure high visibility and a spacious layout.

### **Technical Summary**
*   **Frontend:** Flutter (Dart) using Material 3 and Google Fonts (Ubuntu).
*   **Backend:** Google Firebase (Core, Firestore).
*   **Architecture:** Organized into a clean `models`, `screens`, `services`, and `widgets` structure for scalability.

**Is there a specific part of the app or the Firebase project you'd like to work on next?**