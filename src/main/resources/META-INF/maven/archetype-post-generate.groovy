// Post-generation script to rename the template gitignore file
// so that the produced project contains a proper .gitignore while
// the archetype project itself is not affected by its rules.

def projectDir = new File(request.outputDirectory)
def templateNames = ["gitignore", "gitignore-template"]
def templateFile = templateNames.collect { new File(projectDir, it) }.find { it.exists() }

if (templateFile) {
    def targetFile = new File(projectDir, ".gitignore")
    if (!targetFile.exists()) {
        def ok = templateFile.renameTo(targetFile)
        if (!ok) {
            println "[archetype-post-generate] WARNING: Failed to rename ${templateFile.name} to .gitignore. Please rename manually."
        } else {
            println "[archetype-post-generate] Renamed ${templateFile.name} -> .gitignore"
        }
    } else {
        println "[archetype-post-generate] .gitignore already exists; leaving ${templateFile.name} in place."
    }
}