
Create a Flutter UI for the "Project Detail" / "Sprint Backlog" screen based on the reference image provided, but with a few specific modifications. The app follows Clean Architecture and uses BLoC.

**Global Navigation (Bottom Navigation Bar):**
* Implement a BottomNavigationBar with exactly 4 items:
  1. DASHBOARD (Icon: grid_view) - Set this as the active tab.
  2. TEAMS (Icon: groups)
  3. LIBRARY (Icon: inventory_2)
  4. SETTINGS (Icon: settings)

**Header Section (AppBar & Toggles):**
* Back button icon (`<`), Title "Mobile Redesign V2" (Bold, Dark), Subtitle "ACTIVE SPRINT" (Small, Primary Blue, Uppercase), and a trailing more_horiz (`...`) icon.
* Below the AppBar, create a row with two toggle-style expanded buttons: 
  - "Repository" (Active state: light blue background, primary blue text/icon).
  - "Test Plans" (Inactive state: white background, gray text/icon, light gray border).

**Search & Filter:**
* A search text field with the hint "Search user stories..." and a leading search icon.
* A filter icon button next to the search bar.

**User Story List (Main Content - Custom Expansion Panels):**
* Use a `ListView.builder` for the list.
* **Important Modification:** DO NOT include the "Generate Tests" button shown in the reference image.
* **Expanded Card State (e.g., US-204):**
  - Header: US ID badge (e.g., "US-204" in a light blue container with blue text). A trailing expand-less arrow.
  - Body: Use `RichText` to format the User Story standard: "AS A [bold] returning user, I WANT TO [bold] log in... SO THAT [bold] I can...".
  - Divider.
  - Section Title: "ACCEPTANCE CRITERIA" (Gray, uppercase) and a trailing status badge (e.g., "2/3 Done" in a light green container with dark green text).
  - Checklist: A column of CheckboxListTile-like widgets showing the criteria.
* **Collapsed Card State (e.g., US-205, US-206):**
  - Header: US ID badge (use different colors like light orange or light purple). Trailing expand-more arrow.
  - Body: 2 lines of truncated description text.
  - Footer row: Small icons and text showing stats like "5 ACs" and "12 Tests" or an "AI Ready" badge.

**Floating Action Button:**
* A large, primary blue FAB with a white `+` icon positioned at the bottom right, above the BottomNavigationBar.

**Styling:**
* Use a very light gray background for the Scaffold (`Color(0xFFF6F7F8)` or similar).
* Cards should have white backgrounds, subtle borders/shadows, and 16px border radius.

Code UI, but you need remove button Generate Tests:
    <!DOCTYPE html>
<html class="light" lang="en"><head>
<meta charset="utf-8"/>
<meta content="width=device-width, initial-scale=1.0" name="viewport"/>
<title>Project Stories &amp; AC List</title>
<script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&amp;display=swap" rel="stylesheet"/>
<link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&amp;display=swap" rel="stylesheet"/>
<script id="tailwind-config">
        tailwind.config = {
            darkMode: "class",
            theme: {
                extend: {
                    colors: {
                        "primary": "#2b7cee",
                        "background-light": "#f6f7f8",
                        "background-dark": "#101822",
                    },
                    fontFamily: {
                        "display": ["Inter", "sans-serif"]
                    },
                    borderRadius: {
                        "DEFAULT": "0.25rem",
                        "lg": "0.5rem",
                        "xl": "0.75rem",
                        "full": "9999px"
                    },
                },
            },
        }
    </script>
<style>
        body {
            font-family: 'Inter', sans-serif;
            min-height: 100dvh;
        }
        .material-symbols-outlined {
            font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24;
        }
        .no-scrollbar::-webkit-scrollbar {
            display: none;
        }
        .no-scrollbar {
            -ms-overflow-style: none;
            scrollbar-width: none;
        }
    </style>
<style>
    body {
      min-height: max(884px, 100dvh);
    }
  </style>
  </head>
<body class="bg-background-light dark:bg-background-dark">
<div class="relative flex min-h-screen w-full flex-col overflow-x-hidden pb-24">
<div class="sticky top-0 z-50 bg-white/80 dark:bg-background-dark/80 backdrop-blur-md border-b border-gray-100 dark:border-gray-800">
<div class="flex items-center px-4 py-3 justify-between">
<button class="flex items-center justify-center rounded-lg h-10 w-10 text-gray-600 dark:text-gray-300">
<span class="material-symbols-outlined">arrow_back_ios_new</span>
</button>
<div class="flex-1 text-center">
<h1 class="text-[#111418] dark:text-white text-lg font-bold leading-tight">Mobile Redesign V2</h1>
<p class="text-[10px] text-primary font-bold uppercase tracking-widest">Active Sprint</p>
</div>
<button class="flex items-center justify-center rounded-lg h-10 w-10 text-gray-600 dark:text-gray-300">
<span class="material-symbols-outlined">more_horiz</span>
</button>
</div>
<div class="flex gap-2 px-4 pb-4">
<button class="flex-1 flex items-center justify-center gap-2 bg-primary/10 text-primary py-2.5 rounded-xl font-semibold text-sm">
<span class="material-symbols-outlined text-lg">folder_open</span>
                    Repository
                </button>
<button class="flex-1 flex items-center justify-center gap-2 bg-white dark:bg-gray-800 border border-gray-100 dark:border-gray-700 text-gray-700 dark:text-gray-200 py-2.5 rounded-xl font-semibold text-sm">
<span class="material-symbols-outlined text-lg">assignment</span>
                    Test Plans
                </button>
</div>
</div>
<div class="px-4 py-4">
<div class="flex gap-2">
<div class="relative flex-1">
<span class="material-symbols-outlined absolute left-3 top-1/2 -translate-y-1/2 text-gray-400 text-xl">search</span>
<input class="w-full h-11 pl-10 pr-4 bg-white dark:bg-gray-800 border-none rounded-xl text-sm focus:ring-2 focus:ring-primary/20 text-[#111418] dark:text-white placeholder:text-gray-400 shadow-sm" placeholder="Search user stories..." type="text"/>
</div>
<button class="h-11 w-11 flex items-center justify-center bg-white dark:bg-gray-800 rounded-xl shadow-sm border border-transparent">
<span class="material-symbols-outlined text-gray-500">tune</span>
</button>
</div>
</div>
<div class="flex flex-col gap-4 px-4">
<div class="bg-white dark:bg-gray-800 rounded-2xl border border-gray-100 dark:border-gray-700 shadow-sm overflow-hidden">
<div class="p-4">
<div class="flex items-start justify-between gap-3 mb-3">
<div class="bg-blue-50 dark:bg-blue-900/30 text-blue-600 dark:text-blue-400 text-[10px] font-bold px-2 py-1 rounded-md uppercase tracking-wider">US-204</div>
<span class="material-symbols-outlined text-gray-300">expand_less</span>
</div>
<div class="space-y-2 mb-4">
<p class="text-[#111418] dark:text-white text-sm leading-relaxed">
<span class="font-bold text-gray-400 uppercase text-[11px]">As a</span> returning user,
                        </p>
<p class="text-[#111418] dark:text-white text-sm leading-relaxed">
<span class="font-bold text-gray-400 uppercase text-[11px]">I want to</span> log in with biometric authentication,
                        </p>
<p class="text-[#111418] dark:text-white text-sm leading-relaxed">
<span class="font-bold text-gray-400 uppercase text-[11px]">So that</span> I can access my account faster.
                        </p>
</div>
<div class="mt-4 pt-4 border-t border-gray-50 dark:border-gray-700">
<div class="flex items-center justify-between mb-3">
<h4 class="text-xs font-bold text-gray-500 uppercase tracking-widest">Acceptance Criteria</h4>
<span class="text-[10px] bg-green-50 text-green-600 px-2 py-0.5 rounded-full font-bold">2/3 Done</span>
</div>
<div class="space-y-3">
<div class="flex items-start gap-3">
<div class="mt-0.5 h-5 w-5 rounded border border-primary bg-primary flex items-center justify-center shrink-0">
<span class="material-symbols-outlined text-white text-sm font-bold">check</span>
</div>
<span class="text-sm text-gray-600 dark:text-gray-300">Show biometric prompt on app launch if enabled in settings.</span>
</div>
<div class="flex items-start gap-3">
<div class="mt-0.5 h-5 w-5 rounded border border-primary bg-primary flex items-center justify-center shrink-0">
<span class="material-symbols-outlined text-white text-sm font-bold">check</span>
</div>
<span class="text-sm text-gray-600 dark:text-gray-300">Fallback to PIN entry if biometric fails after 3 attempts.</span>
</div>
<div class="flex items-start gap-3">
<div class="mt-0.5 h-5 w-5 rounded border-2 border-gray-300 dark:border-gray-600 shrink-0"></div>
<span class="text-sm text-gray-600 dark:text-gray-300">Provide toggle in Profile settings to enable/disable feature.</span>
</div>
</div>
<div class="mt-4 flex gap-2">
<button class="flex-1 py-2 bg-primary/5 text-primary text-xs font-bold rounded-lg flex items-center justify-center gap-1">
<span class="material-symbols-outlined text-base">auto_awesome</span>
                                Generate Tests
                            </button>
</div>
</div>
</div>
</div>
<div class="bg-white dark:bg-gray-800 rounded-2xl border border-gray-100 dark:border-gray-700 shadow-sm overflow-hidden">
<div class="p-4">
<div class="flex items-start justify-between gap-3 mb-3">
<div class="bg-orange-50 dark:bg-orange-900/30 text-orange-600 dark:text-orange-400 text-[10px] font-bold px-2 py-1 rounded-md uppercase tracking-wider">US-205</div>
<span class="material-symbols-outlined text-gray-400">expand_more</span>
</div>
<div class="space-y-1">
<p class="text-[#111418] dark:text-white text-sm font-medium line-clamp-2">
                            As a new user, I want to see a walkthrough of the app features so that I understand how to navigate.
                        </p>
</div>
<div class="mt-3 flex items-center gap-4">
<div class="flex items-center gap-1 text-gray-400">
<span class="material-symbols-outlined text-sm">checklist</span>
<span class="text-xs font-medium">5 ACs</span>
</div>
<div class="flex items-center gap-1 text-gray-400">
<span class="material-symbols-outlined text-sm">science</span>
<span class="text-xs font-medium">12 Tests</span>
</div>
</div>
</div>
</div>
<div class="bg-white dark:bg-gray-800 rounded-2xl border border-gray-100 dark:border-gray-700 shadow-sm overflow-hidden">
<div class="p-4">
<div class="flex items-start justify-between gap-3 mb-3">
<div class="bg-purple-50 dark:bg-purple-900/30 text-purple-600 dark:text-purple-400 text-[10px] font-bold px-2 py-1 rounded-md uppercase tracking-wider">US-206</div>
<span class="material-symbols-outlined text-gray-400">expand_more</span>
</div>
<div class="space-y-1">
<p class="text-[#111418] dark:text-white text-sm font-medium line-clamp-2">
                            As a customer, I want to receive push notifications for my transactions so that I can monitor my spending in real-time.
                        </p>
</div>
<div class="mt-3 flex items-center gap-4">
<div class="flex items-center gap-1 text-gray-400">
<span class="material-symbols-outlined text-sm">checklist</span>
<span class="text-xs font-medium">4 ACs</span>
</div>
<div class="flex items-center gap-1 text-primary">
<span class="material-symbols-outlined text-sm">auto_awesome</span>
<span class="text-xs font-bold">AI Ready</span>
</div>
</div>
</div>
</div>
</div>
<button class="fixed bottom-24 right-4 size-14 bg-primary text-white rounded-full shadow-lg flex items-center justify-center z-40 transition-transform active:scale-95">
<span class="material-symbols-outlined text-3xl">add</span>
</button>
<div class="fixed bottom-0 w-full bg-white/95 dark:bg-background-dark/95 backdrop-blur-md border-t border-gray-100 dark:border-gray-800 flex justify-around items-center h-20 px-6 z-50">
<div class="flex flex-col items-center gap-1 text-gray-400">
<span class="material-symbols-outlined">grid_view</span>
<span class="text-[10px] font-bold uppercase tracking-tight">Projects</span>
</div>
<div class="flex flex-col items-center gap-1 text-primary">
<span class="material-symbols-outlined font-bold" style="font-variation-settings: 'FILL' 1">list_alt</span>
<span class="text-[10px] font-bold uppercase tracking-tight">Stories</span>
</div>
<div class="flex flex-col items-center gap-1 text-gray-400">
<span class="material-symbols-outlined">play_circle</span>
<span class="text-[10px] font-bold uppercase tracking-tight">Runs</span>
</div>
<div class="flex flex-col items-center gap-1 text-gray-400">
<span class="material-symbols-outlined">analytics</span>
<span class="text-[10px] font-bold uppercase tracking-tight">Reports</span>
</div>
</div>
</div>

</body></html>