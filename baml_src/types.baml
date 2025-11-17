enum ComponentType {
    Route
    Middleware
    Utility
    Configuration
    Model
    Service
    Component
    Page
    Layout
    Admin
}

enum DesignSystem {
    Shadcn
    Material
    Antd
    Custom
    NoDesignSystem @alias("none")
}

enum TestType {
    Unit
    Integration
    E2e
}

enum AnalyticsProvider {
    Posthog
    Mixpanel
    Custom
    NoAnalytics @alias("none")
}

enum CommandType {
    CreateFile
    UpdateFile
    DeleteFile
    ReadFile     // enable this later while the agent is also allowed to edit
}

class NextJSProjectComponent {
    type ComponentType
    command CommandType @description("which command needs to be run for this particular component")
    filePath string @description(`the path where this command needs to be run. example of filepath would look like "app/components/Button.tsx"`)
    current_code string @description("gives back the current code which was already present in this file and returns empty string when there was none")
    name string
    description string
    dependencies string[] @description("List of other components this depends on")
    specific_instructions string @description("Step-by-step instructions for implementation (5-7 numbered steps, very explicit)")
    expected_behavior string @description("Exactly what this component should do")
    input_validation string @description("If applicable, validation rules for inputs, return empty string if its not needed")
    error_handling string @description("How errors should be handled")
    example_usage string @description("Example of how this would be used, return empty string if its not needed")
    design_guidelines string @description("Design system guidelines, Tailwind classes, responsive breakpoints, accessibility requirements. Return empty string if not applicable.")
    test_requirements TestType[] @description("Types of tests required for this component")
    analytics_events string[] @description("Analytics events to track for this component (e.g., ['button_clicked', 'form_submitted']). Return empty array if not applicable.")
}

class FeatureTemplate {
    name string @description("Name of the feature template (e.g., 'auth', 'payments', 'user-profile')")
    description string @description("What this template provides")
    components string[] @description("List of component names that are part of this template")
    dependencies string[] @description("Package dependencies required for this template")
}

class ProjectStructure {
    components NextJSProjectComponent[]
    entry_point string @description("Main file that ties everything together")
    package_dependencies string[] @description("Only include dependencies mentioned in user prompt or required by feature templates")
    file_structure string[] @description("List of files that need to be created")
    implementation_order string[] @description("Order in which components should be implemented")
    design_system DesignSystem @description("Design system to use for the project")
    analytics_provider AnalyticsProvider @description("Analytics provider to integrate")
    feature_templates FeatureTemplate[] @description("Reusable feature templates (auth, payments, etc.) that can be referenced")
    testing_setup string @description("Testing framework setup instructions (Jest, React Testing Library, Playwright)")
}

class RouteGeneratorOutput {
    componentType ComponentType
    routeName string
    dependencies string[] @description("list of dependency that might be required for the creation of this route")
    final_code string
}