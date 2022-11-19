//
//  main.swift
//  MyCreditManager
//
//  Created by 김태윤 on 2022/11/16.
//

import Foundation
enum Score:Double{
    case Aplus = 4.5, A = 4, Bplus = 3.5, B = 3, Cplus = 2.5, C = 2, Dplus = 1.5, D = 1, F = 0
    init?(_ raw:String){
        switch raw{
        case "A+": self =  .Aplus
        case "A": self =  .A
        case "B+": self =  .Bplus
        case "B": self = .B
        case "C+": self = .Cplus
        case "C": self = .C
        case "D+": self = .Dplus
        case "D": self = .D
        case "F": self = .F
        default: return nil
        }
    }
}
typealias Name = String
typealias Subject = String
typealias SubjectInfos = [Subject:Score]
extension SubjectInfos{
    func getScoreAvg()-> Double{ self.values.map { $0.rawValue}.reduce(0) { $0 + $1 } }
}
typealias Students = [Name : SubjectInfos]
extension Students{
    func isContained(_ name:Name)->Bool{ self[name] != nil }
    mutating func add(_ name: Name){
        self[name] = [:]
    }
    mutating func delete(_ name:Name){
        self[name] = nil
    }

}
func coreLogics(_ cases:[(Action,Target)])->[()->()]{
    var students = Students()
    func actionFunc(action: Action,target: Target)->(()->()){
        switch (action,target){
        case (.append,.student):
            return {
                Output(.cmd, .inputGuide(.event(action: action, target: target)))
                guard let input:Name = readLine() else {
                    Output(.cmd, .inputGuide(.event(action: action, target: target)))
                    return
                }
                if !students.isContained(input){
                    students.add(input)
                    Output(.cmd, .completed(.event(action: action, target: target)),input)
                }else{
                    Output(.cmd, .error(type: .event(action: action, target: target)),input)
                }
            }
        case (.delete,.student):
            return {
                Output(.cmd, .inputGuide(.event(action: .delete, target: .student)))
                guard let input:Name = readLine() else { return }
                if !students.isContained(input){
                    Output(.cmd, .error(type: .event(action: .delete, target: .student)), input)
                }else{
                    students.delete(input)
                    Output(.cmd, .completed(.event(action: .delete, target: .student)), input)
                }
            }
        case (.append,.subject):
            return {
                Output(.cmd, .inputGuide(.event(action: .append, target: .subject)))
                guard let input:String = readLine() else {
                    Output(.cmd, .error(type: .input))
                    return
                }
                var inputsIter = input.components(separatedBy: " ").makeIterator()
                guard let name:Name = inputsIter.next(),
                      let subject:Subject = inputsIter.next(),
                      let rawScore = inputsIter.next() else {
                    Output(.cmd, .error(type: .input))
                    return
                }
                guard let score:Score = Score(rawScore) else {
                    Output(.cmd, .error(type: .input))
                    return}
                guard students.isContained(name) else {
                    Output(.cmd, .error(type: .event(action: .append, target: .subject)), name)
                    return }
                students[name]?[subject] = score
                Output(.cmd, .completed(.event(action: .append, target: .subject)), name,subject,rawScore)
            }
        case (.delete,.subject):
            return {
                Output(.cmd, .inputGuide(.event(action: .delete, target: .student)))
                guard let input:String = readLine() else {
                    Output(.cmd, .error(type: .input))
                    return
                }
                var inputsIter = input.components(separatedBy: " ").makeIterator()
                guard let name:Name = inputsIter.next(),
                      let subject:Subject = inputsIter.next() else {
                    Output(.cmd, .error(type: .input))
                    return
                }
                students[name]?.removeValue(forKey: subject)
                Output(.cmd, .completed(.event(action: .delete, target: .subject)), name,subject)
            }
        }
    }
    func rateFunc(){
        Output(.cmd, .inputGuide(.rate))
        guard let name:Name = readLine() else{
            Output(.cmd, .error(type: .input))
            return
        }
        guard students.isContained(name) else {
            Output(.cmd, .error(type: .rate))
            return
        }
        let subjectInfos = students[name]!
        subjectInfos.forEach { (key: Subject, value: Score) in print("\(key): \(value)") }
        Output(.cmd, .completed(.rate), String(subjectInfos.getScoreAvg()))
    }

    let logics: [()->()] = cases.map { act,tar in actionFunc(action: act, target: tar) }
    let myLogics:[()->()] = [logics, [rateFunc]].flatMap { $0 }
    print(myLogics)
    return myLogics
}
func Runner(caseList:[(Action,Target)]){
    let cmdList = coreLogics(caseList)
    Output(.cmd,.inputGuide(.base))
    while let input = readLine(){
        guard input != "X" else {
            Output(.cmd, .quitProcess)
            return
        }
        guard let number:Int = Int(input), (0<=number && number <= cmdList.count) else {
            Output(.cmd, .error(type: .input))
            continue
        }
        cmdList[number - 1]()
        Output(.cmd,.inputGuide(.base))
    }
}
func MyCreditManager(){
    let cases:[(Action,Target)] = [ (.append,.student), (.delete,.student), (.append,.subject), (.delete,.subject) ]
    Runner(caseList: cases)
}
MyCreditManager()
