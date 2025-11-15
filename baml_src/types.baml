enum ComponentType {
    Route
    Middleware
    Utility
    Configuration
    Model
    Service
}

enum CommandType {
    CreateFile
    UpdateFile
    DeleteFile
    // ReadFile     // enable this later while the agent is also allowed to edit
}

class ProjectComponent {
    type ComponentType
    command CommandType @description("which command needs to be run for this particular component")
    filePath string @description(`the path where this command needs to be run. example of filepath would look like "src/middleware.ts"`)
    current_code string @description("gives back the current code which was already present in this file and returns empty string when there was none")
    name string
    description string
    dependencies string[] @description("List of other components this depends on")
    specific_instructions string @description("Step-by-step instructions for implementation")
    expected_behavior string @description("Exactly what this component should do")
    input_validation string @description("If applicable, validation rules for inputs, return empty string if its not needed")
    error_handling string @description("How errors should be handled")
    example_usage string @description("Example of how this would be used, return empty string if its not needed")
}

class ProjectStructure {
    components ProjectComponent[]
    entry_point string @description("Main file that ties everything together")
    package_dependencies string[] @description("Only include dependencies mentioned in user prompt")
    file_structure string[] @description("List of files that need to be created")
    implementation_order string[] @description("Order in which components should be implemented")
}

class RouteGeneratorOutput {
    componentType ComponentType
    routeName string
    dependencies string[] @description("list of dependency that might be required for the creation of this route")
    final_code string
}