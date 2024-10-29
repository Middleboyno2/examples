package ua.acclorite.book_story.domain.model

import androidx.compose.runtime.Immutable
import ua.acclorite.book_story.domain.util.Selected

@Immutable
enum class Category {
    READING, ALREADY_READ
}

@Immutable
data class CategorizedBooks(
    val category: Category,
    val books: List<Pair<Book, Selected>>
)