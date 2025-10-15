import PocketBase from 'pocketbase';
import { faker } from '@faker-js/faker';

const pb = new PocketBase('http://127.0.0.1:8090');

await pb.admins.authWithPassword('admin@gmail.com', 'en12345678');

const TOTAL = 20;

const categories = ['ทั่วไป', 'ผ่อนคลาย', 'การงาน/เรียน', 'ทัศนคติ/ความคิด'];

for (let i = 0; i < TOTAL; i++) {
  await pb.collection('questions').create({
    text: faker.lorem.sentence(), 
    category: faker.helpers.arrayElement(categories), 
    favorite: false, 
  });
  console.log(`✅ เพิ่มคำถามที่ ${i + 1}`);
}

console.log('🎉 สร้างข้อมูลจำลองเสร็จเรียบร้อยแล้ว!');
