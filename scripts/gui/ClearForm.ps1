function ClearForm {
    param (
        [ref]$form
    )
    
    # Remove all controls except those marked with Tag "footer"
    $controlsToRemove = $form.Value.Controls | Where-Object { $_.Tag -ne "footer" }
    
    foreach ($control in $controlsToRemove) {
        $form.Value.Controls.Remove($control)
    }

    # Optionally refresh the form after clearing
    $form.Value.Refresh()
}
