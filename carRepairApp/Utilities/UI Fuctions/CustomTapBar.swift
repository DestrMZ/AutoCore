//
//  CustomTapBar.swift
//  carRepairApp
//
//  Created by Ivan Maslennikov on 28.10.2024.
//

import SwiftUI

/// `CustomTapBar` - это пользовательский компонент таб-бара для навигации по различным разделам приложения.
struct CustomTapBar: View {
    
    /// Перечисление для определения доступных вкладок в таб-баре.
    enum TabItems: Int, Identifiable {
        var id: Int { self.rawValue } // Уникальный идентификатор для каждой вкладки.
        
        case cars = 0          // Вкладка "Автомобили".
        case repair            // Вкладка "Ремонт".
        case statistics        // Вкладка "Статистика".
        case settings          // Вкладка "Настройки".
    }
    
    /// Структура для представления элемента вкладки с изображением и типом вкладки.
    struct TabItem {
        let imageName: String // Имя изображения для вкладки.
        let type: TabItems    // Тип вкладки, связанный с перечислением `TabItems`.
    }
    
    /// Массив элементов вкладок с соответствующими изображениями и типами.
    private let items = [
        TabItem(imageName: "car.2", type: .cars),          // Вкладка "Автомобили".
        TabItem(imageName: "wrench", type: .repair),       // Вкладка "Ремонт".
        TabItem(imageName: "chart.bar", type: .statistics), // Вкладка "Статистика".
        TabItem(imageName: "gearshape", type: .settings)   // Вкладка "Настройки".
    ]
    
    /// Привязка к текущей выбранной вкладке. Позволяет обновлять состояние из родительского компонента.
    @Binding var selectedTab: TabItems
    
    /// Переменная состояния для масштабирования выбранной вкладки.
    @State private var scale = 1.0
    
    /// Ширина элемента вкладки.
    private let tabItemWidth = 60.0
    
    /// Цвет для индикатора выбранной вкладки.
    private let indicatorColor = Color(red: 244/255.0, green: 103/255.0, blue: 111/255.0)
    
    /// Основное тело представления.
    var body: some View {
        
        ZStack {
            // Горизонтальный стек для размещения элементов вкладок.
            HStack {
                Spacer() // Пробел слева для центровки элементов.
                
                // Цикл по элементам вкладок для отображения их на экране.
                ForEach(items, id: \.type) { item in
                    Image(systemName: item.imageName) // Отображение изображения для текущей вкладки.
                        .frame(width: tabItemWidth, height: tabItemWidth) // Задание размеров изображения.
                        .contentShape(Rectangle()) // Определение области нажатия для элемента.
                        .scaleEffect(selectedTab == item.type ? scale : 1.0) // Изменение масштаба при выборе.
                        .symbolVariant(selectedTab == item.type ? .fill : .none) // Заполнение значка при выборе.
                        .foregroundStyle(selectedTab == item.type ? .primary : .secondary) // Цвет значка в зависимости от выбора.
                        .onTapGesture {
                            // Обработчик нажатия на элемент.
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                                selectedTab = item.type // Обновление выбранной вкладки.
                                scale = 1.1 // Увеличение масштаба.
                            }
                        }
                    Spacer() // Пробел между элементами вкладок.
                }
            }
            
            // Вертикальный стек для размещения индикатора выбранной вкладки.
            VStack(alignment: .leading) {
                Spacer() // Пробел сверху.
                HStack {
                    leadingSpacers() // Добавление пробелов слева от индикатора.
                    
                    // Индикатор выбранной вкладки.
                    Capsule()
                        .frame(width: 32, height: 3) // Размер индикатора.
//                        .offset(x: -1) // Сдвиг индикатора.
                        .foregroundStyle(Color.red) // Цвет индикатора.
                        .padding(.horizontal, 14) // Внутренние отступы по горизонтали.
                        .shadow(color: Color.black, radius: 5, x: 0, y: -1) // Тень для индикатора.
                    
                    trailingSpacers() // Добавление пробелов справа от индикатора.
                }
            }
            .frame(maxWidth: .infinity) // Задание максимальной ширины для вертикального стека.
        }
        .frame(maxWidth: .infinity) // Задание максимальной ширины для основного представления.
        .frame(height: 64) // Фиксированная высота для таб-бара.
        .background(.thinMaterial, in: .capsule) // Фон с закругленными краями.
        .shadow(color: .black.opacity(0.6), radius: 0.0, y: 0.5) // Тень для таб-бара.
        .padding() // Внешние отступы.
    }
    
    // MARK: - Dynamic spacing
    
    /// Функция для добавления пробелов слева от индикатора в зависимости от выбранной вкладки.
    @ViewBuilder
    func leadingSpacers() -> some View {
        let leadingMaxIndex = selectedTab.rawValue + 1 // Максимальный индекс пробелов.
        ForEach(0..<leadingMaxIndex, id: \.self) { _ in
            Spacer() // Добавление пробела.
        }
        Spacer().frame(width: tabItemWidth * CGFloat((leadingMaxIndex - 1))) // Дополнительный пробел для выравнивания.
    }
    
    /// Функция для добавления пробелов справа от индикатора в зависимости от выбранной вкладки.
    @ViewBuilder
    func trailingSpacers() -> some View {
        let trailingMaxIndex = items.count - selectedTab.rawValue // Максимальный индекс пробелов справа.
        ForEach(0..<trailingMaxIndex, id: \.self) { _ in
            Spacer() // Добавление пробела.
        }
        Spacer().frame(width: tabItemWidth * CGFloat(trailingMaxIndex - 1)) // Дополнительный пробел для выравнивания.
    }
}

//#Preview {
//    @Previewable @State var selectedTab: CustomTapBar.TabItems = .cars
//    CustomTapBar(selectedTab: $selectedTab)
//}
