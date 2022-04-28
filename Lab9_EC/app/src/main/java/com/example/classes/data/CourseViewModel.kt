import androidx.lifecycle.*
import com.example.classes.data.Course
import com.example.classes.roomUtil.CourseDatabase

class CourseViewModel: ViewModel() {
    private val coursedb = CourseDatabase()
    val options = coursedb.getOptions()
    fun add(course: Course){
        coursedb.add(course)
    }
    fun delete(id: String){
        coursedb.delete(id)
    }
}