// Post-generation script to rename the template gitignore file
// so that the produced project contains a proper .gitignore while
// the archetype project itself is not affected by its rules.

def projectDir = new File(request.outputDirectory, request.artifactId)
def templateNames = ["gitignore", "gitignore-template"]
def templateFile = templateNames.collect { new File(projectDir, it) }.find { it.exists() }

println "[archetype-post-generate] Checking for template gitignore file..."
println "[archetype-post-generate] Project directory: ${projectDir.absolutePath}"
println "[archetype-post-generate] Found template file: ${templateFile?.name ?: 'none'}"

if (templateFile) {
    println "[archetype-post-generate] Attempting to rename ${templateFile.name} to .gitignore"
    def targetFile = new File(projectDir, ".gitignore")
    if (!targetFile.exists()) {
        def ok = templateFile.renameTo(targetFile)
        if (!ok) {
            println "[archetype-post-generate] WARNING: Failed to rename ${templateFile.name} to .gitignore. Please rename manually."
        } else {
            println "[archetype-post-generate] SUCCESS: Renamed ${templateFile.name} -> .gitignore"
        }
    } else {
        println "[archetype-post-generate] .gitignore already exists; leaving ${templateFile.name} in place."
    }
} else {
    println "[archetype-post-generate] ERROR: No gitignore template file found in ${projectDir.absolutePath}"
}