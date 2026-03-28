<script setup lang="ts">
import { ref } from 'vue';
import ProfileThumbLayout from '@/common/layout/slot/ProfileThumbLayout.vue';
import AlertLayout from '@/common/layout/slot/AlertLayout.vue';
import { onClickOutside } from '@vueuse/core';
import ConfirmCancelButton from '@/common/component/ConfirmCancelButton.vue';

const props = withDefaults(defineProps<{
  show: boolean;
  userId: string;
  profilealertFlag: boolean;
}>(), {
})

const emits = defineEmits<{
  close: []
  ok: [value: File]
}>()

const onClose = () => {
  emits("close");
}

const File = ref<File | null>(null);
const isVibration = ref(false);
const alertFlag = ref(false);
const modalText = ref("");

const setFile = (file: File) => {
  File.value = file;
}

const alertModal = (announceText: string) => {
  modalText.value = announceText;
  alertFlag.value = true;
}

const onOk = () => {
  if (File.value) {
    emits('ok', File.value)
  }
}

const target = ref<HTMLElement | null>(null);
onClickOutside(target, () => {
  onClose();
})

</script>

<template>
  <Transition name="modal">
    <div v-if="show" class="modal">
      <div ref="target" :class="['modal__container', { 'modal__container--vibration': isVibration }]">
        <div class="modal__header">
          <slot name="header">프로필 사진</slot>
        </div>

        <div class="modal__alert" v-if="props.profilealertFlag">
          <p>서버 오류로 파일이 정상적으로 업로드 되지 않았습니다.</p>
          <p>
            잠시 후 시도바랍니다.
          </p>
        </div>

        <div class="modal__body">
          <ProfileThumbLayout :userId="`${props.userId}`" @announce="alertModal" @send-file="setFile">
          </ProfileThumbLayout>
        </div>

        <div>
          <hr>
        </div>

        <div class="modal__footer">
          <slot name="footer">
            <confirm-cancel-button @ok="onOk" @close="onClose"></confirm-cancel-button>
          </slot>
        </div>

      </div>
    </div>
  </Transition>


  <Teleport to="body">
    <!-- use the modal component, pass in the prop -->
    <alert-layout :show="alertFlag" :flag="false" @close="alertFlag = false">
      <template #header>
        경고
      </template>
      <template #body>
        ${{ modalText }}
      </template>
    </alert-layout>
  </Teleport>
</template>

<style lang="scss" scoped>
@use "@/common/asset/css/global" as *;


.modal {
  position: fixed;
  z-index: 9998;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background-color: rgb(0 0 0 / 50%);
  display: flex;
  transition: opacity 0.3s ease;
  overflow-y: auto;
}

.modal__container {
  width: 500px;
  margin: auto;
  padding: 20px;
  background-color: #fff;
  border-radius: 15px;
  box-shadow: 0 2px 8px rgb(0 0 0 / 33%);
  transition: all 0.3s ease;

  .modal__alert {
    color: $red;
    font-size: font-size(base);
  }
}

.modal__header {
  text-align: left;
  margin-top: 0;
  font-weight: bold;
  font-size: font-size(lg);
}

.modal__body {
  text-align: left;
  font-size: font-size(md);
  display: flex;
  row-gap: 20px;
  flex-direction: column;
  margin-bottom: 10px;
}


/*
 * The following styles are auto-applied to elements with
 * transition="modal" when their visibility is toggled
 * by Vue.js.
 *
 * You can easily play with the modal transition by editing
 * these styles.
 */

.modal-enter-from {
  opacity: 0;
}

.modal-leave-to {
  opacity: 0;
}

.modal-enter-from .modal__container,
.modal-leave-to .modal__container {
  transform: scale(1.1);
}

.modal__container--vibration {
  animation: vibration 0.1s infinite;

  /* 빠르게 무한 반복 */
}

/* 잘못된 걸 눌렀을 때 진동효과 */
@keyframes vibration {

  0%,
  100% {
    transform: translateX(0);
  }

  20% {
    transform: translateX(-2px);
  }

  40% {
    transform: translateX(2px);
  }

  60% {
    transform: translateX(-2px);
  }

  80% {
    transform: translateX(2px);
  }
}
</style>