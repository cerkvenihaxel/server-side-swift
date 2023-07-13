import Fluent
import Vapor

func routes(_ app: Application) throws {
   
    //This function returns all data inside Exam table
    app.get("exam"){req -> [Exam] in
        return try await Exam.query(on: req.db).all()
    }
    
    //This function retrieve all the exams given a specified id
       app.get("exam",":id"){req -> [Exam] in
           guard let number = req.parameters.get("id", as: String.self) else {
               throw Abort(.badRequest)
           }
           return try await Exam.query(on: req.db).filter(\.$exam_id == number).all()
       }
    
    //This function create a new exam using a json file
      app.post("exam"){req -> Exam in
          let data = try req.content.decode(Exam.self)
          let exam = Exam(id: data.id, name: data.name, course: data.course, exam_id: data.exam_id)
          
          try await exam.save(on: req.db)
          
          return exam
      }
    
    
    //This function delete a specific exam using an id
       app.delete("exam",":id"){req -> String in
           guard let number = req.parameters.get("id", as: String.self) else {
               throw Abort(.badRequest)
           }
           
           Exam.query(on: req.db).filter(\.$exam_id == number).delete()
           return "Success"
       }
    
    
    
    
    

}
