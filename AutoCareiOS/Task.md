#                                      Task
---------------------------------------------------------------------------------------------------------------------------------------------------

Задачи на завтра: 

3. Подумать как можно оформить "AddCarView" более строгом и современном виде
9. Попробовать реализовать функционал, чтобы даты скрывались по месяца в ListRepairs

Проверка на реальном устройстве показала
5. Исправить баг при нажатии на SearchBar смещается кнопка добавить ремонт +


------ 

Первое что нужно сделать, это разобраться с рамерами subView, в View DashboardView можно привести к единообразию с использованием .frame(maxWidth:), .fixedSize(), GeometryReader (по необходимости) и системных отступов. Это точно стоит сделать в первую очередь, чтобы всё выглядело ровно.


Второе, продумать обновление пробега, после создания ремонта, обновдлять или оставлять так как есть тут можно подумать: если в AddRepair передаётся пробег и он выше текущего, логично обновить его в selectedCar. Иначе оставить как есть. Возможно, стоит завести один метод в CarService для сравнения и обновления.


Третье, subView страховки добавить функционал по его отображению, а также добавить кнопку для редактирования -- аккуратная кнопка «изменить» в InsuranceCardView с передачей данных в модальный Sheet — это будет удобный UX и легко реализуемо.


Интеграция с картами
Предлагай ближайшие заправки или СТО (можно сделать через MKMapView + вручную подгрузить данные).

Сканирование чеков на заправке (OCR)
Используй VisionKit (или сторонний SDK), чтобы быстро внести данные о расходах.

    // insurance
    @NSManaged public var id: UUID
    @NSManaged public var type: String
    @NSManaged public var nameCompany: String
    @NSManaged public var startDate: Date
    @NSManaged public var endDate: Date
    @NSManaged public var price: Int32
    @NSManaged public var notes: String?
    @NSManaged public var notificationDate: Date?
    @NSManaged public var isActive: Bool
    @NSManaged public var car: Car?
    
    // car
    @NSManaged public var id: UUID
    @NSManaged public var color: String?
    @NSManaged public var engineType: String
    @NSManaged public var existingVinNumbers: [String]?
    @NSManaged public var mileage: Int32
    @NSManaged public var nameModel: String
    @NSManaged public var photoCar: Data
    @NSManaged public var stateNumber: String?
    @NSManaged public var transmissionType: String
    @NSManaged public var vinNumber: String
    @NSManaged public var year: Int16
    @NSManaged public var repairs: NSSet?
    @NSManaged public var insurance: NSSet?
    
    // repair
    @NSManaged public var id: UUID
    @NSManaged public var amount: Int32
    @NSManaged public var litresFuel: NSNumber?
    @NSManaged public var notes: String?
    @NSManaged public var partReplaced: String
    @NSManaged public var parts: [String: String]?
    @NSManaged public var photoRepair: [Data]?
    @NSManaged public var repairCategory: String
    @NSManaged public var repairDate: Date
    @NSManaged public var repairMileage: Int32
    @NSManaged public var car: Car?
